import 'package:flutter/material.dart';
import 'package:lesson_base_arignar/theme/app_colors.dart';
import 'package:lesson_base_arignar/theme/app_text_styles.dart';
import 'package:lesson_base_arignar/widgets/density/scalable_text.dart';
import 'package:lesson_base_arignar/widgets/quiz_header.dart';
import 'package:lesson_base_arignar/widgets/question_container.dart';
import 'package:lesson_base_arignar/widgets/quiz_image.dart';
import 'package:lesson_base_arignar/widgets/quiz_options.dart';
import 'package:lesson_base_arignar/widgets/quiz_bottom_bar.dart';
import 'responsive/responsive.dart';

void main() {
  runApp(const LessonBaseApp());
}

class LessonBaseApp extends StatelessWidget {
  const LessonBaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lesson Base',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryBlue),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.lightYellowBackground,
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(0.85)),
          child: child!,
        );
      },
      routes: {
        '/': (context) => const SimpleTaskWrapper(),
        '/simple-task': (context) => const SimpleTaskWrapper(),
      },
    );
  }
}

class SimpleTaskWrapper extends StatelessWidget {
  const SimpleTaskWrapper({super.key});

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: ScalableText(
          message,
          style: AppTextStyles.bodyMedium(
            context,
          ).copyWith(color: AppColors.white, fontWeight: FontWeight.w600),
          autoScale: false,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color.fromARGB(211, 255, 153, 0),
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.only(top: 50, left: 16, right: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, responsive) {
        // ZOOM-STABLE LAYOUT: Always use 100% width with NO centering or scaling
        return SizedBox(
          width: double.infinity, // Always 100% width regardless of zoom
          height: double.infinity, // Always 100% height regardless of zoom
          child: _EmbeddedAwareSimpleTask(
            onReady: () {},
            chapterID: 'chapter-001',
            lessonID: 'lesson-001',
            onLessonComplete: () => _showSnackBar(context, 'Lesson Complete!'),
            onExitPressed: () => _showSnackBar(context, 'Exit tapped'),
            onJumpToQuestion: () =>
                _showSnackBar(context, 'Jump to Question tapped'),
            onPrevLessonPressed: () =>
                _showSnackBar(context, 'Reached first lesson'),
          ),
        );
      },
    );
  }
}

class _EmbeddedAwareSimpleTask extends StatefulWidget {
  const _EmbeddedAwareSimpleTask({
    required this.onReady,
    required this.chapterID,
    required this.lessonID,
    required this.onLessonComplete,
    required this.onExitPressed,
    required this.onJumpToQuestion,
    required this.onPrevLessonPressed,
  });

  final VoidCallback onReady;
  final String chapterID;
  final String lessonID;
  final VoidCallback onLessonComplete;
  final VoidCallback onExitPressed;
  final VoidCallback onJumpToQuestion;
  final VoidCallback onPrevLessonPressed;

  @override
  State<_EmbeddedAwareSimpleTask> createState() =>
      _EmbeddedAwareSimpleTaskState();
}

class _EmbeddedAwareSimpleTaskState extends State<_EmbeddedAwareSimpleTask> {
  List<Map<String, dynamic>> lessons = [];
  int currentLessonIndex = 0;
  int? selectedOptionIndex;
  bool? isCurrentAnswerCorrect;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  void _loadLessons() {
    final demoLessons = [
      {
        'title': 'இயற்கை & பருவங்கள்',
        'question':
            'குளிர்காலத்திற்குப் பிறகும் கோடைகாலத்திற்கு முன்பும் வரும் பருவம் எது?',
        'image':
            'https://images.unsplash.com/photo-1490750967868-88aa4486c946?w=400',
        'options': [
          'இது பனி மற்றும் பனிக்கட்டி உள்ள குளிரான பருவம்.',
          'இது மலர்கள் பூக்கும் மற்றும் மரங்கள் புதிய இலைகள் வளரும் பருவம்.',
          'இது நீண்ட சூரிய ஒளி நாட்கள் உள்ள வெப்பமான பருவம்.',
          'இது இலைகள் நிறம் மாறி விழும் பருவம்.',
        ],
        'correctIndex': 1,
      },
      {
        'title': 'உணவு & சமையல்',
        'question': 'காலையில் சாப்பிடும் உணவை என்ன அழைக்கிறீர்கள்?',
        'image':
            'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=400',
        'options': [
          'இது நாளின் முதல் உணவு, பொதுவாக மதியத்திற்கு முன் சாப்பிடப்படுகிறது.',
          'இது நண்பகலில் சாப்பிடும் உணவு.',
          'இது மாலையில் சாப்பிடும் உணவு.',
          'இது இரவில் சாப்பிடும் உணவு.',
        ],
        'correctIndex': 0,
      },
      {
        'title': 'உடல் பாகங்கள்',
        'question': 'உடலின் எந்த பகுதி பார்ப்பதற்கு உதவுகிறது?',
        'image':
            'https://images.unsplash.com/photo-1574169208507-84376144848b?w=400',
        'options': [
          'இவை உங்களைச் சுற்றியுள்ள ஒலிகளைக் கேட்பதற்குப் பயன்படுகின்றன.',
          'இவை உங்களைச் சுற்றியுள்ள வாசனையை உணர உதவுகின்றன.',
          'இவை உங்களைச் சுற்றியுள்ள உலகைப் பார்க்க உதவுகின்றன.',
          'இவை உணவை சுவைக்க உதவுகின்றன.',
        ],
        'correctIndex': 2,
      },
    ];

    setState(() {
      lessons = demoLessons;
      isLoaded = true;
    });
  }

  Map<String, dynamic>? get currentLesson {
    if (currentLessonIndex < lessons.length) {
      return lessons[currentLessonIndex];
    }
    return null;
  }

  void _onOptionSelected(int index) {
    setState(() {
      selectedOptionIndex = index;
      isCurrentAnswerCorrect = index == (currentLesson!['correctIndex'] as int);
    });

    // Show feedback popup after selection
    _showAnswerFeedback(index);
  }

  // Show device-adaptive answer feedback
  void _showAnswerFeedback(int selectedIndex) {
    final isCorrect = selectedIndex == (currentLesson!['correctIndex'] as int);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    if (isMobile) {
      _showMobileFeedback(isCorrect, selectedIndex);
    } else {
      _showDesktopFeedback(isCorrect, selectedIndex);
    }
  }

  // Mobile bottom-sheet style feedback
  void _showMobileFeedback(bool isCorrect, int selectedIndex) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true, // Essential for dynamic height
      useSafeArea: true,
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        return Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: screenWidth * 0.9, // 90% of screen width
            maxHeight: screenHeight * 0.85, // Max 85% of screen height
            minHeight: screenHeight * 0.3, // Minimum reasonable height
          ),
          margin: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, // 5% margin on each side
          ),
          decoration: const BoxDecoration(
            color: Color(0xFFFAF8EF),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x30000000),
                blurRadius: 25,
                offset: Offset(0, -6),
                spreadRadius: 3,
              ),
            ],
          ),
          child: _buildFeedbackContent(isCorrect, selectedIndex, true),
        );
      },
    );
  }

  // Desktop centered dialog feedback
  void _showDesktopFeedback(bool isCorrect, int selectedIndex) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        // Responsive width based on screen size
        double dialogWidth;
        if (screenWidth < 600) {
          dialogWidth = screenWidth * 0.85; // Mobile: 85%
        } else if (screenWidth < 1024) {
          dialogWidth = screenWidth * 0.55; // Tablet: 55%
        } else {
          dialogWidth = screenWidth * 0.4; // Desktop: 40%
        }

        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: dialogWidth,
            constraints: BoxConstraints(
              maxWidth: dialogWidth,
              minWidth: 300,
              maxHeight: screenHeight * 0.9, // Max 90% of screen height
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF8EF),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                  spreadRadius: 5,
                ),
              ],
            ),
            child: _buildFeedbackContent(isCorrect, selectedIndex, false),
          ),
        );
      },
    );
  }

  // Build responsive feedback content with dynamic height and no overflow
  Widget _buildFeedbackContent(
    bool isCorrect,
    int selectedIndex,
    bool isMobile,
  ) {
    final correctOption =
        currentLesson!['options'][currentLesson!['correctIndex']] as String;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive sizing based on screen dimensions
    final isCompactScreen = screenWidth < 400 || screenHeight < 600;

    // Adaptive dimensions
    final basePadding = isCompactScreen ? 12.0 : (isMobile ? 16.0 : 20.0);
    final iconSize = isCompactScreen ? 45.0 : (isMobile ? 55.0 : 65.0);
    final iconInnerSize = isCompactScreen ? 24.0 : (isMobile ? 30.0 : 36.0);
    final titleFontSize = isCompactScreen ? 18.0 : (isMobile ? 22.0 : 26.0);
    final labelFontSize = isCompactScreen ? 12.0 : (isMobile ? 14.0 : 16.0);
    final answerFontSize = isCompactScreen ? 13.0 : (isMobile ? 15.0 : 17.0);
    final buttonHeight = isCompactScreen ? 42.0 : (isMobile ? 48.0 : 54.0);
    final buttonFontSize = isCompactScreen ? 14.0 : (isMobile ? 16.0 : 18.0);
    final spacing = isCompactScreen ? 8.0 : (isMobile ? 12.0 : 16.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Scrollable content area
        Flexible(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.all(basePadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close indicator for mobile
                if (isMobile) ...[
                  Container(
                    width: 32,
                    height: 3,
                    margin: EdgeInsets.only(bottom: spacing),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: spacing * 0.5),
                ],

                // Feedback icon
                Container(
                  width: iconSize,
                  height: iconSize,
                  decoration: BoxDecoration(
                    color: isCorrect
                        ? const Color(0xFF4CAF50).withOpacity(0.15)
                        : const Color(0xFFE53935).withOpacity(0.15),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: isCorrect
                            ? const Color(0xFF4CAF50).withOpacity(0.2)
                            : const Color(0xFFE53935).withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    isCorrect
                        ? Icons.check_circle_rounded
                        : Icons.error_rounded,
                    color: isCorrect
                        ? const Color(0xFF43A047)
                        : const Color(0xFFD32F2F),
                    size: iconInnerSize,
                  ),
                ),

                SizedBox(height: spacing * 1.2),

                // Title
                Text(
                  isCorrect
                      ? _getRandomCorrectMessage()
                      : 'Oops! That\'s not correct.',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: isCorrect
                        ? const Color(0xFF43A047)
                        : const Color(0xFFD32F2F),
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                // Wrong answer content
                if (!isCorrect) ...[
                  SizedBox(height: spacing * 1.5),

                  // Correct answer label
                  Text(
                    'Correct answer is:',
                    style: TextStyle(
                      fontSize: labelFontSize,
                      color: const Color(0xFF757575),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: spacing),

                  // Auto-expanding correct answer container
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: basePadding * 1.2,
                      vertical: basePadding * 0.8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF4CAF50).withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4CAF50).withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      correctOption,
                      style: TextStyle(
                        fontSize: answerFontSize,
                        color: const Color(0xFF43A047),
                        fontWeight: FontWeight.w600,
                        height: 1.4, // Good line spacing for Tamil text
                      ),
                      textAlign: TextAlign.left,
                      softWrap: true, // Enable text wrapping
                      maxLines: null, // No line limit
                      overflow: TextOverflow.visible, // No clipping
                    ),
                  ),
                ],

                SizedBox(height: spacing * 2),
              ],
            ),
          ),
        ),

        // Fixed continue button at bottom
        Padding(
          padding: EdgeInsets.fromLTRB(
            basePadding,
            0,
            basePadding,
            basePadding +
                (isMobile ? MediaQuery.of(context).padding.bottom : 0),
          ),
          child: Container(
            width: double.infinity,
            height: buttonHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isCorrect
                    ? [const Color(0xFF4CAF50), const Color(0xFF43A047)]
                    : [const Color(0xFFE53935), const Color(0xFFD32F2F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isCorrect
                      ? const Color(0xFF4CAF50).withOpacity(0.3)
                      : const Color(0xFFE53935).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  _nextQuestion();
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Get random motivational message for correct answers
  String _getRandomCorrectMessage() {
    final messages = [
      'Well done!',
      'Great job!',
      'Wow!',
      'Super!',
      'Excellent!',
      'Amazing!',
    ];
    return messages[(DateTime.now().millisecond) % messages.length];
  }

  void _nextQuestion() {
    if (selectedOptionIndex != null) {
      if (currentLessonIndex < lessons.length - 1) {
        setState(() {
          currentLessonIndex++;
          selectedOptionIndex = null;
          isCurrentAnswerCorrect = null;
        });
      } else {
        widget.onLessonComplete();
      }
    }
  }

  void _previousQuestion() {
    if (currentLessonIndex > 0) {
      setState(() {
        currentLessonIndex--;
        selectedOptionIndex = null;
        isCurrentAnswerCorrect = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      return const Scaffold(
        backgroundColor: Color(0xFFFAF8EF),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF8F00)),
          ),
        ),
      );
    }

    return ResponsiveBuilder(
      builder: (context, responsive) {
        // FLEXIBLE RESPONSIVE DESIGN - No scaling, pure adaptive layout
        return Scaffold(
          backgroundColor: const Color(0xFFFAF8EF),
          body: SafeArea(
            child: Column(
              children: [
                // Header - flexible and adaptive
                QuizHeader(
                  currentQuestion: currentLessonIndex + 1,
                  totalQuestions: lessons.length,
                  progressPercentage:
                      ((currentLessonIndex + 1) / lessons.length) * 100,
                  title: currentLesson?['title'] ?? '',
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Adaptive sizing based on available space
                      final screenWidth = constraints.maxWidth;

                      // ACCESSIBILITY-FIRST adaptive padding - Larger padding for better touch targets
                      final adaptivePadding = screenWidth < 300
                          ? 12.0 // Very small screens need reasonable padding
                          : screenWidth < 450
                          ? 16.0 // Small screens get good padding
                          : screenWidth < 600
                          ? 20.0 // Medium screens get generous padding
                          : 24.0; // Large screens get maximum padding

                      return SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: adaptivePadding,
                          vertical: adaptivePadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Intelligent adaptive question container
                            QuestionContainer(
                              question: currentLesson?['question'] ?? '',
                              onSpeakerTap: () {},
                            ),
                            SizedBox(height: adaptivePadding),
                            if (currentLesson?['image'] != null) ...[
                              QuizImage(
                                imageUrl: currentLesson!['image'] as String,
                              ),
                              SizedBox(height: adaptivePadding),
                            ],
                            if (currentLesson?['options'] != null)
                              QuizOptions(
                                options: List<String>.from(
                                  currentLesson!['options'],
                                ),
                                selectedIndex: selectedOptionIndex,
                                isAnswerCorrect: isCurrentAnswerCorrect,
                                correctIndex:
                                    currentLesson!['correctIndex'] as int,
                                onOptionSelected: _onOptionSelected,
                              ),
                            SizedBox(height: adaptivePadding * 1.5),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: QuizBottomBar(
            onHomePressed: widget.onExitPressed,
            onBackPressed: _previousQuestion,
            onNextPressed: _nextQuestion,
            canGoBack: currentLessonIndex > 0,
            canGoNext: selectedOptionIndex != null,
          ),
        );
      },
    );
  }
}
