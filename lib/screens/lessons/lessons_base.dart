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
    final isCompact = MediaQuery.of(context).size.width < 420;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScalableText(
          'Lesson ${currentLessonIndex + 1} of ${lessons.length}',
          minFontSize: isCompact ? 11 : 13,
          maxFontSize: isCompact ? 16 : 18,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: isCompact ? 6 : 8),
        LinearProgressIndicator(
          value: lessons.isEmpty
              ? 0
              : (currentLessonIndex + 1) / lessons.length.toDouble(),
          backgroundColor: AppColors.border,
          color: AppColors.primaryBlue,
          minHeight: isCompact ? 5 : 8,
          borderRadius: BorderRadius.circular(8),
        ),
        if (isCurrentAnswerCorrect != null) ...[
          SizedBox(height: isCompact ? 8 : 10),
          DecoratedBox(
            decoration: BoxDecoration(
              color: isCurrentAnswerCorrect!
                  ? AppColors.success.withOpacity(0.12)
                  : AppColors.error.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color:
                      (isCurrentAnswerCorrect!
                              ? AppColors.success
                              : AppColors.error)
                          .withOpacity(0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(isCompact ? 8 : 10),
              child: ScalableText(
                isCurrentAnswerCorrect! ? 'Correct!' : 'Try again!',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isCurrentAnswerCorrect!
                      ? AppColors.success
                      : AppColors.error,
                ),
                minFontSize: 13,
                maxFontSize: 20,
              ),
            ),
          ),
        ],
      ],
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
