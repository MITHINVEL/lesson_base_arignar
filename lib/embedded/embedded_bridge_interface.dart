import 'package:flutter/foundation.dart';

typedef LessonListener = void Function(EmbeddedLessonMetadata metadata);

/// Describes the chapter/lesson metadata sent from the host portal.
class EmbeddedLessonMetadata {
  EmbeddedLessonMetadata({
    required this.chapterId,
    this.referenceId,
    this.referenceType,
    this.locale,
    this.profileId,
    this.classCode,
    this.title,
    this.subtitle,
    this.rawData = const <String, dynamic>{},
  });

  factory EmbeddedLessonMetadata.fromMap(Map<dynamic, dynamic> map) {
    return EmbeddedLessonMetadata(
      chapterId: map['chapterId']?.toString() ?? '',
      referenceId: map['referenceId']?.toString(),
      referenceType: map['referenceType']?.toString(),
      locale: map['locale']?.toString(),
      profileId: map['profileId']?.toString(),
      classCode: map['classCode']?.toString(),
      title: map['title']?.toString(),
      subtitle: map['subtitle']?.toString(),
      rawData: Map<String, dynamic>.from(map.cast<String, dynamic>()),
    );
  }

  final String chapterId;
  final String? referenceId;
  final String? referenceType;
  final String? locale;
  final String? profileId;
  final String? classCode;
  final String? title;
  final String? subtitle;
  final Map<String, dynamic> rawData;

  Map<String, dynamic> toJson() => {
    'chapterId': chapterId,
    if (referenceId != null) 'referenceId': referenceId,
    if (referenceType != null) 'referenceType': referenceType,
    if (locale != null) 'locale': locale,
    if (profileId != null) 'profileId': profileId,
    if (classCode != null) 'classCode': classCode,
    if (title != null) 'title': title,
    if (subtitle != null) 'subtitle': subtitle,
  };
}

abstract class EmbeddedBridge {
  bool get isEmbedded;
  bool get isInitialized;
  ValueListenable<EmbeddedLessonMetadata?> get lessonMetadata;

  void initialize();

  VoidCallback addLessonListener(LessonListener listener);

  void notifyChapterDisplayed(EmbeddedLessonMetadata metadata);

  void notifyReady();

  void dispose();
}
