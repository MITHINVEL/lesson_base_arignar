// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

import 'embedded_bridge_interface.dart';

EmbeddedBridge createEmbeddedBridge() => _EmbeddedBridgeWeb();

class _EmbeddedBridgeWeb implements EmbeddedBridge {
  final ValueNotifier<EmbeddedLessonMetadata?> _metadata =
      ValueNotifier<EmbeddedLessonMetadata?>(null);
  final List<void Function(EmbeddedLessonMetadata metadata)> _listeners = [];

  bool _initialized = false;
  bool _isEmbedded = false;
  String _targetOrigin = '*';
  late final StreamSubscription<html.Event> _messageSubscription;

  @override
  bool get isEmbedded => _isEmbedded;

  @override
  bool get isInitialized => _initialized;

  @override
  ValueListenable<EmbeddedLessonMetadata?> get lessonMetadata => _metadata;

  @override
  void initialize() {
    if (_initialized) return;
    _initialized = true;

    final parent = html.window.parent;
    _isEmbedded = parent != null && parent != html.window;

    if (!_isEmbedded) {
      return;
    }

    _messageSubscription = html.window.onMessage.listen(
      _handleMessage,
      onError: (error) {
        debugPrint('[EmbeddedBridge] message error: $error');
      },
    );

    _postToParent('ARIGNAR_INITIATED');
    debugPrint('[EmbeddedBridge] Initialized and notified parent');
  }

  @override
  VoidCallback addLessonListener(
    void Function(EmbeddedLessonMetadata metadata) listener,
  ) {
    _listeners.add(listener);
    final current = _metadata.value;
    if (current != null) {
      listener(current);
    }
    return () {
      _listeners.remove(listener);
    };
  }

  @override
  void notifyChapterDisplayed(EmbeddedLessonMetadata metadata) {
    if (!_isEmbedded) return;
    _postToParent('ARIGNAR_CHAPTER_LOADED', metadata.toJson());
  }

  @override
  void notifyReady() {
    if (!_isEmbedded) return;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _postToParent('ARIGNAR_READY');
    });
  }

  void _handleMessage(html.MessageEvent event) {
    if (!_isEmbedded) return;

    if (event.data is! Map) {
      debugPrint('[EmbeddedBridge] Ignoring non-map message ${event.data}');
      return;
    }

    _targetOrigin = event.origin;
    final data = Map<String, dynamic>.from(event.data as Map);
    final type = data['type']?.toString() ?? '';
    final Map<String, dynamic> payload = data['data'] is Map
        ? Map<String, dynamic>.from(data['data'] as Map)
        : <String, dynamic>{};

    debugPrint('[EmbeddedBridge] Received $type payload=$payload');

    switch (type) {
      case 'INIT_AUTH':
        _handleInitAuth(payload);
        break;
      case 'INIT_PROFILE':
        _handleInitProfile(payload);
        break;
      case 'INIT_CHAPTER':
      case 'INIT_READY_STATE':
        _handleInitChapter(payload);
        break;
    }
  }

  void _handleInitAuth(Map<String, dynamic> payload) {
    _postToParent('AUTH_SUCCESS', {
      'profileId': payload['auth']?['profileId'] ?? payload['profileId'],
    });
  }

  void _handleInitProfile(Map<String, dynamic> payload) {
    _postToParent('ARIGNAR_PROFILE_LOADED', payload);
  }

  void _handleInitChapter(Map<String, dynamic> payload) {
    final metadata = EmbeddedLessonMetadata.fromMap(payload);
    _metadata.value = metadata;
    for (final listener in List.of(_listeners)) {
      listener(metadata);
    }

    notifyChapterDisplayed(metadata);
    notifyReady();
  }

  void _postToParent(String type, [Map<String, dynamic>? data]) {
    if (!_isEmbedded) return;
    final parent = html.window.parent;
    if (parent == null) {
      return;
    }
    parent.postMessage({
      'type': type,
      if (data != null) 'data': data,
    }, _targetOrigin);
    debugPrint('[EmbeddedBridge] Sent $type to $_targetOrigin');
  }

  @override
  void dispose() {
    if (_isEmbedded) {
      _messageSubscription.cancel();
    }
    _listeners.clear();
  }
}
