import 'package:flutter/material.dart';
import 'package:lesson_base_arignar/theme/app_colors.dart';
import 'package:lesson_base_arignar/theme/app_text_styles.dart';
import 'package:lesson_base_arignar/widgets/density/scalable_text.dart';
import 'package:lesson_base_arignar/widgets/quiz_header.dart';
import 'package:lesson_base_arignar/widgets/question_container.dart';
import 'package:lesson_base_arignar/widgets/quiz_image.dart';
import 'package:lesson_base_arignar/widgets/quiz_options.dart';

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

        // Enhanced responsive width calculation for zoom support
        // Support 1366px @ 150% zoom (effective 911px) and all other scenarios
        double targetWidth;
        if (screenWidth < 400) {
          // Very small screens (old phones)
          targetWidth = screenWidth.clamp(300.0, 380.0);
        } else if (screenWidth < 600) {
          // Mobile screens
          targetWidth = screenWidth.clamp(380.0, 500.0);
        } else if (screenWidth < 900) {
          // Tablet/Zoomed desktop (includes 1366px @ 150% zoom = ~911px)
          targetWidth = screenWidth.clamp(500.0, 720.0);
        } else if (screenWidth < 1200) {
          // Desktop/Laptop
          targetWidth = screenWidth.clamp(600.0, 800.0);
        } else {
          // Large desktop
          targetWidth = screenWidth.clamp(700.0, 900.0);
        }

        return SizedBox(
          width: targetWidth,
          height: constraints.maxHeight,
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

    if (isCurrentAnswerCorrect == true) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          _nextQuestion();
        }
      });
    }
  }

  void _nextQuestion() {
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

    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;

    final verticalSpacing = (screenWidth * 0.04).clamp(16.0, 24.0);
    final horizontalPadding = (screenWidth * 0.03).clamp(12.0, 20.0);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8EF),
      body: SafeArea(
        child: Column(
          children: [
            QuizHeader(
              currentQuestion: currentLessonIndex + 1,
              totalQuestions: lessons.length,
              progressPercentage:
                  ((currentLessonIndex + 1) / lessons.length) * 100,
              title: currentLesson?['title'] ?? '',
              onExitPressed: widget.onExitPressed,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalSpacing,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    QuestionContainer(
                      question: currentLesson?['question'] ?? '',
                      onSpeakerTap: () {},
                    ),
                    SizedBox(height: verticalSpacing),
                    if (currentLesson?['image'] != null) ...[
                      QuizImage(imageUrl: currentLesson!['image'] as String),
                      SizedBox(height: verticalSpacing),
                    ],
                    if (currentLesson?['options'] != null)
                      QuizOptions(
                        options: List<String>.from(currentLesson!['options']),
                        selectedIndex: selectedOptionIndex,
                        onOptionSelected: _onOptionSelected,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
