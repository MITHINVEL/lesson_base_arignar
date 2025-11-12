import 'package:flutter/material.dart';
import 'package:lesson_base_arignar/embedded/embedded_bridge.dart';
import 'package:lesson_base_arignar/layouts/lessons/layouts.dart';
import 'package:lesson_base_arignar/theme/app_colors.dart';
import 'package:lesson_base_arignar/widgets/density/scalable_text.dart';

abstract class LessonsBase extends StatefulWidget {
  const LessonsBase({
    super.key,
    required this.chapterID,
    required this.lessonID,
    required this.onLessonComplete,
    required this.onExitPressed,
    required this.onJumpToQuestion,
    required this.onPrevLessonPressed,
  });

  final String chapterID;
  final String lessonID;
  final VoidCallback onLessonComplete;
  final VoidCallback onExitPressed;
  final VoidCallback onJumpToQuestion;
  final VoidCallback onPrevLessonPressed;
}

abstract class LessonsBaseState<T extends LessonsBase> extends State<T> {
  String displayType = 'Words';
  String skillType = 'Reading';
  List<Map<String, dynamic>> lessons = const [];
  Map<String, dynamic>? currentLesson;
  List<String> wordsToDisplay = const [];
  bool isLoaded = false;
  bool? isCurrentAnswerCorrect;
  int? selectedOptionIndex;
  int? correctOptionIndex;
  int currentLessonIndex = 0;
  EmbeddedLessonMetadata? embeddedMetadata;
  VoidCallback? _removeEmbeddedListener;

  @protected
  void setDisplayType();

  @protected
  void setSkillType();

  @protected
  void setGamesLogic();

  @protected
  Widget getQuestionCard();

  @protected
  Widget getAnswersDisplay();

  @protected
  Widget getListofWords(int index);

  @protected
  Widget getListofImages(int index) {
    return const SizedBox.shrink();
  }

  @protected
  Widget showProgressIndicator() {
    final isCompact = MediaQuery.of(context).size.width < 420;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScalableText(
          'Lesson ${currentLessonIndex + 1} of ${lessons.length}',
          minFontSize: isCompact ? 12 : 14,
          maxFontSize: isCompact ? 18 : 20,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: isCompact ? 8 : 12),
        LinearProgressIndicator(
          value: lessons.isEmpty
              ? 0
              : (currentLessonIndex + 1) / lessons.length.toDouble(),
          backgroundColor: AppColors.border,
          color: AppColors.primaryBlue,
          minHeight: isCompact ? 6 : 10,
          borderRadius: BorderRadius.circular(8),
        ),
        if (isCurrentAnswerCorrect != null) ...[
          SizedBox(height: isCompact ? 10 : 14),
          DecoratedBox(
            decoration: BoxDecoration(
              color: isCurrentAnswerCorrect!
                  ? AppColors.success.withOpacity(0.12)
                  : AppColors.error.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(isCompact ? 10 : 12),
              child: ScalableText(
                isCurrentAnswerCorrect! ? 'Correct!' : 'Try again!',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isCurrentAnswerCorrect!
                      ? AppColors.success
                      : AppColors.error,
                ),
                minFontSize: 14,
                maxFontSize: 22,
              ),
            ),
          ),
        ],
      ],
    );
  }

  String get lessonTitle =>
      embeddedMetadata?.title ??
      currentLesson?['title'] ??
      'Lesson ${widget.lessonID}';

  @override
  void initState() {
    super.initState();
    setDisplayType();
    setSkillType();
    setGamesLogic();
    if (embeddedBridge.isEmbedded) {
      embeddedBridge.initialize();
      _removeEmbeddedListener = embeddedBridge.addLessonListener(
        _handleEmbeddedLesson,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AdaptiveLessonLayout(
          lessonTitle: lessonTitle,
          questionCard: getQuestionCard(),
          mainContent: getAnswersDisplay(),
          progressContent: showProgressIndicator(),
          onExitPressed: widget.onExitPressed,
          onPrevPressed: () => previousQuestion(),
          onNextPressed: () => nextQuestion(),
          onJumpToQuestion: widget.onJumpToQuestion,
        );
      },
    );
  }

  void verifyWords(int selectedIndex) {
    setState(() {
      selectedOptionIndex = selectedIndex;
      isCurrentAnswerCorrect = selectedIndex == correctOptionIndex;
    });
  }

  void nextQuestion() {
    if (lessons.isEmpty) return;

    setState(() {
      currentLessonIndex = (currentLessonIndex + 1).clamp(
        0,
        lessons.length - 1,
      );
      loadLesson(currentLessonIndex);
    });

    if (currentLessonIndex == lessons.length - 1) {
      widget.onLessonComplete();
    }
  }

  void previousQuestion() {
    if (lessons.isEmpty) return;

    setState(() {
      currentLessonIndex = (currentLessonIndex - 1).clamp(
        0,
        lessons.length - 1,
      );
      loadLesson(currentLessonIndex);
    });

    if (currentLessonIndex == 0) {
      widget.onPrevLessonPressed();
    }
  }

  @protected
  void loadLesson(int index) {
    if (lessons.isEmpty) return;
    currentLessonIndex = index.clamp(0, lessons.length - 1);
    final nextLesson = lessons[currentLessonIndex];
    final options = (nextLesson['options'] as List<dynamic>? ?? const [])
        .cast<String>();
    final question = nextLesson['question'] ?? nextLesson['word'];
    final correctIdx = nextLesson['correctIndex'] as int? ?? 0;

    currentLesson = {...nextLesson, 'question': question, 'options': options};
    wordsToDisplay = List<String>.from(options);
    correctOptionIndex = correctIdx.clamp(0, options.length - 1);
    selectedOptionIndex = null;
    isCurrentAnswerCorrect = null;
  }

  void _handleEmbeddedLesson(EmbeddedLessonMetadata metadata) {
    if (!mounted) return;
    setState(() {
      embeddedMetadata = metadata;
      if (lessons.isNotEmpty) {
        loadLesson(currentLessonIndex);
      }
      if (currentLesson != null && (metadata.title?.isNotEmpty ?? false)) {
        currentLesson = {...currentLesson!, 'title': metadata.title!};
      }
    });
  }

  @override
  void dispose() {
    _removeEmbeddedListener?.call();
    super.dispose();
  }
}
