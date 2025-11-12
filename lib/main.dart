import 'package:flutter/material.dart';
import 'package:lesson_base_arignar/embedded/embedded_bridge.dart';
import 'package:lesson_base_arignar/screens/tasks/simple_task.dart';
import 'package:lesson_base_arignar/theme/app_colors.dart';
import 'package:lesson_base_arignar/theme/app_text_styles.dart';
import 'package:lesson_base_arignar/widgets/density/scalable_text.dart';

void main() {
  embeddedBridge.initialize();
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
        scaffoldBackgroundColor: AppColors.lightGrey,
      ),
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
        backgroundColor: AppColors.primaryBlue,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        width: double.infinity,
        height: double.infinity,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Use 100% of container width since HTML portal already handles sidebar width
            final targetWidth = constraints.maxWidth.clamp(
              320.0,
              constraints.maxWidth,
            );

            return SizedBox(
              width: targetWidth,
              height: constraints.maxHeight,
              child: _EmbeddedAwareSimpleTask(
                onReady: () => embeddedBridge.notifyReady(),
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
            );
          },
        ),
      ),
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
  bool _sentReady = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_sentReady && embeddedBridge.isEmbedded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onReady();
          _sentReady = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleTask(
      chapterID: widget.chapterID,
      lessonID: widget.lessonID,
      onLessonComplete: widget.onLessonComplete,
      onExitPressed: widget.onExitPressed,
      onJumpToQuestion: widget.onJumpToQuestion,
      onPrevLessonPressed: widget.onPrevLessonPressed,
    );
  }
}
