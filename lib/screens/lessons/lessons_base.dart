import 'package:flutter/material.dart';
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
  List<Map<String, dynamic>> lessons = [];
  Map<String, dynamic>? currentLesson;
  List<String> wordsToDisplay = [];
  bool isLoaded = false;
  bool? isCurrentAnswerCorrect;
  int? selectedOptionIndex;
  int? correctOptionIndex;
  int currentLessonIndex = 0;
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final progressValue = lessons.isEmpty
            ? 0.0
            : (currentLessonIndex + 1) / lessons.length.toDouble();
        final percentage = lessons.isEmpty
            ? 0
            : ((currentLessonIndex + 1) / lessons.length * 100).round();

        // Flexible sizing based on available width
        final availableWidth = constraints.maxWidth;
        final isCompact = availableWidth < 300;
        final isSmall = availableWidth < 400;

        final horizontalPadding = isCompact ? 4.0 : (isSmall ? 8.0 : 12.0);
        final verticalPadding = isCompact ? 6.0 : (isSmall ? 8.0 : 12.0);
        final progressHeight = isCompact ? 5.0 : (isSmall ? 6.0 : 8.0);

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Flexible(
                    flex: 0,
                    child: ScalableText(
                      '${currentLessonIndex + 1}/${lessons.length}',
                      minFontSize: isCompact ? 10 : 12,
                      maxFontSize: isCompact ? 12 : 14,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.darkText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isCompact ? 8 : 12,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(progressHeight / 2),
                        child: LinearProgressIndicator(
                          value: progressValue,
                          backgroundColor: AppColors.progressTrackGrey,
                          color: AppColors.progressRed,
                          minHeight: progressHeight,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 0,
                    child: ScalableText(
                      '$percentage%',
                      minFontSize: isCompact ? 10 : 12,
                      maxFontSize: isCompact ? 12 : 14,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.darkText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              if (isCurrentAnswerCorrect != null) ...[
                SizedBox(height: isCompact ? 8 : 12),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isCurrentAnswerCorrect!
                        ? AppColors.success.withOpacity(0.12)
                        : AppColors.error.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(isCompact ? 8 : 12),
                    border: Border.all(
                      color:
                          (isCurrentAnswerCorrect!
                                  ? AppColors.success
                                  : AppColors.error)
                              .withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  padding: EdgeInsets.all(isCompact ? 8 : 12),
                  child: ScalableText(
                    isCurrentAnswerCorrect! ? 'Correct!' : 'Try again!',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isCurrentAnswerCorrect!
                          ? AppColors.success
                          : AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                    minFontSize: isCompact ? 12 : 14,
                    maxFontSize: isCompact ? 16 : 20,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  String get lessonTitle =>
      currentLesson?['title'] ?? 'Lesson ${widget.lessonID}';

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

  @override
  void initState() {
    super.initState();
    // Initialize display type and skill type
    setDisplayType();
    setSkillType();
    // Load lessons data
    setGamesLogic();
  }

  @protected
  void loadLesson(int index) {
    if (lessons.isEmpty) {
      print('Warning: loadLesson called but lessons is empty');
      return;
    }

    currentLessonIndex = index.clamp(0, lessons.length - 1);
    final nextLesson = lessons[currentLessonIndex];

    final options = (nextLesson['options'] as List<dynamic>? ?? <dynamic>[])
        .map((e) => e.toString())
        .toList();

    if (options.isEmpty) {
      print(
        'Warning: No options found for lesson at index $currentLessonIndex',
      );
    }

    final question =
        nextLesson['question']?.toString() ??
        nextLesson['word']?.toString() ??
        '';
    final correctIdx = (nextLesson['correctIndex'] as int?) ?? 0;

    setState(() {
      currentLesson = {...nextLesson, 'question': question, 'options': options};
      wordsToDisplay = List<String>.from(options);
      correctOptionIndex = correctIdx.clamp(0, options.length - 1);
      selectedOptionIndex = null;
      isCurrentAnswerCorrect = null;
    });

    print(
      'Loaded lesson $currentLessonIndex: question="$question", options count=${options.length}',
    );
  }

  @override
  void dispose() {
    _removeEmbeddedListener?.call();
    super.dispose();
  }
}
