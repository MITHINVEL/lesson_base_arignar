import 'package:flutter/foundation.dart';

import 'embedded_bridge_interface.dart';

EmbeddedBridge createEmbeddedBridge() => _EmbeddedBridgeStub();

class _EmbeddedBridgeStub implements EmbeddedBridge {
  final ValueNotifier<EmbeddedLessonMetadata?> _metadata =
      ValueNotifier<EmbeddedLessonMetadata?>(null);

  @override
  VoidCallback addLessonListener(
    void Function(EmbeddedLessonMetadata metadata) listener,
  ) {
    return () {};
  }

  @override
  void dispose() {}

  @override
  bool get isEmbedded => false;

  @override
  bool get isInitialized => true;

  @override
  ValueListenable<EmbeddedLessonMetadata?> get lessonMetadata => _metadata;

  @override
  void initialize() {}

  @override
  void notifyChapterDisplayed(EmbeddedLessonMetadata metadata) {}

  @override
  void notifyReady() {}
}
