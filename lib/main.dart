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
import 'dart:math' as math;

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        // FULL FLEX SHRINK MODE - NO FALLBACKS, ALWAYS RENDER
        // Calculate adaptive scaling for ANY screen size and zoom level

        // Base reference dimensions (never used as minimums)
        const baseWidth = 400.0;
        const baseHeight = 600.0;

        // Calculate shrink factors for extreme zoom scenarios
        final widthShrinkFactor = (screenWidth / baseWidth).clamp(0.3, 2.0);
        final heightShrinkFactor = (screenHeight / baseHeight).clamp(0.3, 2.0);

        // Use the smaller factor to ensure content always fits
        final adaptiveScale = math.min(widthShrinkFactor, heightShrinkFactor);

        // Force-fit scaling for extreme zoom (200%+ browser zoom)
        double extremeZoomScale = 1.0;
        if (adaptiveScale < 0.6) {
          // Extreme zoom detected - apply aggressive shrinking
          extremeZoomScale = 0.6; // Reduce by up to 40%
        } else if (adaptiveScale < 0.8) {
          // High zoom detected - apply moderate shrinking
          extremeZoomScale = 0.8; // Reduce by up to 20%
        }

        // RESPONSIVE WIDTH - ALWAYS use available space, never clamp to minimums
        final targetWidth = screenWidth * 0.95; // Use 95% of available width

        return SizedBox(
          width: targetWidth,
          height: constraints.maxHeight,
          child: Transform.scale(
            scale: extremeZoomScale,
            child: _EmbeddedAwareSimpleTask(
              onReady: () {},
              chapterID: 'chapter-001',
              lessonID: 'lesson-001',
              onLessonComplete: () =>
                  _showSnackBar(context, 'Lesson Complete!'),
              onExitPressed: () => _showSnackBar(context, 'Exit tapped'),
              onJumpToQuestion: () =>
                  _showSnackBar(context, 'Jump to Question tapped'),
              onPrevLessonPressed: () =>
                  _showSnackBar(context, 'Reached first lesson'),
            ),
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
      isDismissible: true, // Allow dismissal by tapping outside
      enableDrag: true, // Enable drag to dismiss
      isScrollControlled: true, // Prevent overflow
      useSafeArea: true, // Ensure safe area handling
      builder: (context) => SafeArea(
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight:
                MediaQuery.of(context).size.height * 0.5, // Reduced max height
            minHeight:
                MediaQuery.of(context).size.height * 0.3, // Reduced min height
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
          child: SingleChildScrollView(
            child: _buildFeedbackContent(isCorrect, selectedIndex, true),
          ),
        ),
      ),
    );
  }

  // Desktop centered dialog feedback
  void _showDesktopFeedback(bool isCorrect, int selectedIndex) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allow dismissal by clicking outside
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.35, // Reduced width
            minWidth: 300, // Reduced min width
            maxHeight:
                MediaQuery.of(context).size.height * 0.6, // Reduced height
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
          child: SingleChildScrollView(
            child: _buildFeedbackContent(isCorrect, selectedIndex, false),
          ),
        ),
      ),
    );
  }

  // Build feedback content for both mobile and desktop with zoom-aware scaling
  Widget _buildFeedbackContent(
    bool isCorrect,
    int selectedIndex,
    bool isMobile,
  ) {
    final correctOption =
        currentLesson!['options'][currentLesson!['correctIndex']] as String;

    // Get zoom scaling factor
    final media = MediaQuery.of(context);
    final devicePixelRatio = media.devicePixelRatio;
    final screenWidth = media.size.width;

    // Calculate controlled zoom scaling (very subtle)
    double zoomScale = 1.0;
    if (screenWidth < 1366 && devicePixelRatio > 1.0) {
      // Estimate zoom level from viewport reduction
      final estimatedZoom = (1366 / screenWidth).clamp(1.0, 3.0);
      // Apply extremely controlled scaling (max 6% increase)
      zoomScale = 1.0 + ((estimatedZoom - 1.0) * 0.06);
    }

    // Apply subtle scaling to dimensions
    final scaledPadding = ((isMobile ? 20.0 : 24.0) * zoomScale).clamp(
      16.0,
      32.0,
    );
    final scaledIconSize = ((isMobile ? 80 : 90) * zoomScale).clamp(
      60.0,
      120.0,
    );
    final scaledSpacing = (24.0 * zoomScale).clamp(16.0, 32.0);
    final scaledButtonHeight = ((isMobile ? 52 : 56) * zoomScale).clamp(
      44.0,
      72.0,
    );
    final scaledBorderRadius = (16.0 * zoomScale).clamp(12.0, 24.0);

    return Container(
      padding: EdgeInsets.all(scaledPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Close indicator for mobile (visual only) with zoom scaling
          if (isMobile)
            Container(
              width: 40 * zoomScale,
              height: 4 * zoomScale,
              margin: EdgeInsets.only(bottom: scaledSpacing),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2 * zoomScale),
              ),
            ),

          // Feedback icon with zoom-aware sizing
          Container(
            width: scaledIconSize,
            height: scaledIconSize,
            decoration: BoxDecoration(
              color: isCorrect
                  ? const Color(0xFF4CAF50).withOpacity(0.15)
                  : const Color(0xFFE53935).withOpacity(0.15),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: isCorrect
                      ? const Color(0xFF4CAF50).withOpacity(0.3)
                      : const Color(0xFFE53935).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              isCorrect ? Icons.check_circle_rounded : Icons.error_rounded,
              color: isCorrect
                  ? const Color(0xFF43A047)
                  : const Color(0xFFD32F2F),
              size: isMobile ? 40 : 45,
            ),
          ),

          SizedBox(height: isMobile ? 20 : 24),

          // Feedback title with zoom-aware typography
          Text(
            isCorrect
                ? _getRandomCorrectMessage()
                : 'Oops! That\'s not correct.',
            style: TextStyle(
              fontSize: ((isMobile ? 26 : 28) * zoomScale).clamp(20.0, 36.0),
              fontWeight: FontWeight.bold,
              color: isCorrect
                  ? const Color(0xFF43A047)
                  : const Color(0xFFD32F2F),
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),

          if (!isCorrect) ...[
            SizedBox(height: scaledSpacing * 0.8),

            // Correct answer label with zoom-aware font
            Text(
              'Correct answer is:',
              style: TextStyle(
                fontSize: ((isMobile ? 16 : 18) * zoomScale).clamp(14.0, 24.0),
                color: const Color(0xFF757575),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: isMobile ? 12 : 16),

            // Highlighted correct answer with beautiful container
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 24,
                vertical: isMobile ? 16 : 20,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF4CAF50).withOpacity(0.3),
                  width: 2,
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
                  fontSize: ((isMobile ? 15 : 16) * zoomScale).clamp(
                    13.0,
                    20.0,
                  ),
                  color: const Color(0xFF43A047),
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],

          SizedBox(height: isMobile ? 24 : 28),

          // Beautiful Continue button - Color based on answer correctness
          Container(
            width: double.infinity,
            height: isMobile ? 52 : 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isCorrect
                    ? [
                        const Color(0xFF4CAF50), // Green for correct
                        const Color(0xFF43A047),
                      ]
                    : [
                        const Color(0xFFE53935), // Red for wrong
                        const Color(0xFFD32F2F),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isCorrect
                      ? const Color(0xFF4CAF50).withOpacity(0.4)
                      : const Color(0xFFE53935).withOpacity(0.4),
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
                  // Auto-advance to next question after Continue is tapped
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
                      fontSize: isMobile ? 18 : 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Add bottom safe area padding for mobile
          if (isMobile)
            SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
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
        // FULL FLEX SHRINK MODE - Apply extreme zoom adaptations
        return Transform.scale(
          scale: responsive.customScaleFactor,
          child: Scaffold(
            backgroundColor: const Color(0xFFFAF8EF),
            body: SafeArea(
              child: Column(
                children: [
                  // Header with automatic compact mode
                  QuizHeader(
                    currentQuestion: currentLessonIndex + 1,
                    totalQuestions: lessons.length,
                    progressPercentage:
                        ((currentLessonIndex + 1) / lessons.length) * 100,
                    title: currentLesson?['title'] ?? '',
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      // Adaptive padding based on zoom level
                      padding: responsive.isCompactMode
                          ? const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ) // Ultra-tight for extreme zoom
                          : const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          QuestionContainer(
                            question: currentLesson?['question'] ?? '',
                            onSpeakerTap: () {},
                          ),
                          SizedBox(height: responsive.scaleSpacing(16)),
                          if (currentLesson?['image'] != null) ...[
                            QuizImage(
                              imageUrl: currentLesson!['image'] as String,
                            ),
                            SizedBox(height: responsive.scaleSpacing(16)),
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
                          SizedBox(height: responsive.scaleSpacing(20)),
                        ],
                      ),
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
          ),
        );
      },
    );
  }
}
