import 'package:flutter/material.dart';
import 'package:lesson_base_arignar/theme/app_colors.dart';
import 'package:lesson_base_arignar/theme/app_text_styles.dart';
import 'package:lesson_base_arignar/widgets/density/scalable_text.dart';

class QuizHeader extends StatelessWidget {
  const QuizHeader({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.progressPercentage,
    required this.title,
    required this.onExitPressed,
  });

  final int currentQuestion;
  final int totalQuestions;
  final double progressPercentage;
  final String title;
  final VoidCallback onExitPressed;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;

    // Responsive calculations for 1366px with 150% zoom support
    final isVeryCompact = screenWidth < 400;
    final isCompact = screenWidth < 600;

    // Dynamic padding based on viewport
    final horizontalPadding = (screenWidth * 0.04).clamp(16.0, 24.0);
    final verticalPadding = (screenWidth * 0.02).clamp(12.0, 20.0);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF8EF), // Cream background
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top row: Question counter, progress bar, percentage, exit button
          Row(
            children: [
              // Question counter
              ScalableText(
                '$currentQuestion/$totalQuestions',
                style: AppTextStyles.bodyMedium(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkText,
                ),
                minFontSize: isVeryCompact ? 12 : 14,
                maxFontSize: isVeryCompact ? 14 : 16,
                autoScale: true,
              ),

              const SizedBox(width: 16),

              // Progress bar
              Expanded(
                child: Container(
                  height: isCompact ? 8 : 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(isCompact ? 4 : 5),
                    color: const Color(0xFFE0E0E0), // Soft grey background
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(isCompact ? 4 : 5),
                    child: LinearProgressIndicator(
                      value: progressPercentage / 100,
                      backgroundColor: Colors.transparent,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFFF8F00), // Yellow-orange gradient end
                      ),
                      minHeight: isCompact ? 8 : 10,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Percentage display
              ScalableText(
                '${progressPercentage.toInt()}%',
                style: AppTextStyles.bodyMedium(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkText,
                ),
                minFontSize: isVeryCompact ? 12 : 14,
                maxFontSize: isVeryCompact ? 14 : 16,
                autoScale: true,
              ),

              const SizedBox(width: 16),

              // Exit button
              Material(
                color: const Color(0xFFFF8F00), // Orange
                borderRadius: BorderRadius.circular(isCompact ? 16 : 20),
                elevation: 2,
                child: InkWell(
                  onTap: onExitPressed,
                  borderRadius: BorderRadius.circular(isCompact ? 16 : 20),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isCompact ? 12 : 16,
                      vertical: isCompact ? 6 : 8,
                    ),
                    child: ScalableText(
                      'Exit',
                      style: AppTextStyles.bodyMedium(context).copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      minFontSize: isVeryCompact ? 11 : 12,
                      maxFontSize: isVeryCompact ? 13 : 14,
                      autoScale: true,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: isCompact ? 12 : 16),

          // Title text (centered)
          Center(
            child: ScalableText(
              title,
              style: AppTextStyles.headlineMedium(context).copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.darkText,
              ),
              textAlign: TextAlign.center,
              minFontSize: isVeryCompact ? 16 : (isCompact ? 18 : 20),
              maxFontSize: isVeryCompact ? 18 : (isCompact ? 22 : 26),
              autoScale: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
