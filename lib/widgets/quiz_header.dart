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
    final textScaler = media.textScaler.scale(1.0);

    // Enhanced responsive breakpoints for all devices and zoom levels

    // Intelligent spacing that scales with device size
    final horizontalPadding = screenWidth < 400
        ? 16.0
        : screenWidth < 600
        ? 20.0
        : screenWidth < 900
        ? 24.0
        : screenWidth < 1400
        ? 32.0
        : 40.0;

    final verticalPadding = screenWidth < 400
        ? 8.0
        : // Very slim on mobile
          screenWidth < 600
        ? 10.0
        : // Slim on tablet
          screenWidth < 900
        ? 12.0
        : // Minimal on laptop
          screenWidth < 1400
        ? 14.0
        : 16.0; // Compact on desktop

    // Progress bar height that scales properly
    final progressHeight =
        (screenWidth < 400
            ? 8.0
            : screenWidth < 600
            ? 10.0
            : screenWidth < 900
            ? 12.0
            : screenWidth < 1400
            ? 14.0
            : 16.0) *
        textScaler;

    // Exit button dimensions with enhanced desktop width
    final exitButtonHeight =
        (screenWidth < 400
            ? 36.0
            : screenWidth < 600
            ? 40.0
            : screenWidth < 900
            ? 44.0
            : screenWidth < 1400
            ? 48.0
            : 52.0) *
        textScaler;

    final exitButtonRadius = exitButtonHeight * 0.5;

    // Enhanced width calculation for better desktop appearance
    final exitButtonWidth = screenWidth < 400
        ? 75.0
        : // Mobile
          screenWidth < 600
        ? 85.0
        : // Tablet
          screenWidth < 900
        ? 100.0
        : // Small laptop
          screenWidth < 1400
        ? 130.0
        : 145.0; // Desktop/large

    // Tighter spacing for slimmer look
    final elementSpacing = screenWidth < 400
        ? 10.0
        : screenWidth < 600
        ? 14.0
        : screenWidth < 900
        ? 18.0
        : screenWidth < 1400
        ? 22.0
        : 26.0;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF8EF), // Premium cream background
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top row: Question counter, progress bar, percentage, exit button
          Row(
            children: [
              // Question counter with enhanced responsive sizing
              ScalableText(
                '$currentQuestion/$totalQuestions',
                style: AppTextStyles.bodyMedium(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkText,
                  fontSize: screenWidth < 400
                      ? 13
                      : screenWidth < 600
                      ? 14
                      : screenWidth < 900
                      ? 15
                      : screenWidth < 1400
                      ? 16
                      : 18,
                ),
                autoScale: false,
              ),

              SizedBox(width: elementSpacing),

              // Enhanced progress bar with gradient
              Expanded(
                child: Container(
                  height: progressHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(progressHeight * 0.5),
                    color: const Color(0xFFE0E0E0), // Soft grey background
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(progressHeight * 0.5),
                    child: Stack(
                      children: [
                        LinearProgressIndicator(
                          value: progressPercentage / 100,
                          backgroundColor: Colors.transparent,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFFFF8F00), // Orange end of gradient
                          ),
                          minHeight: progressHeight,
                        ),
                        // Gradient overlay for premium look
                        Container(
                          height: progressHeight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              progressHeight * 0.5,
                            ),
                            gradient: LinearGradient(
                              colors: [
                                const Color(
                                  0xFFFFD54F,
                                ).withOpacity(0.9), // Yellow start
                                const Color(0xFFFF8F00), // Orange end
                              ],
                              stops: const [0.0, 1.0],
                            ),
                          ),
                          width: (progressPercentage / 100) * double.infinity,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(width: elementSpacing),

              // Percentage display with enhanced scaling
              ScalableText(
                '${progressPercentage.toInt()}%',
                style: AppTextStyles.bodyMedium(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkText,
                  fontSize: screenWidth < 400
                      ? 13
                      : screenWidth < 600
                      ? 14
                      : screenWidth < 900
                      ? 15
                      : screenWidth < 1400
                      ? 16
                      : 18,
                ),
                autoScale: false,
              ),

              SizedBox(width: elementSpacing),

              // Premium Exit button with enhanced desktop width
              Container(
                height: exitButtonHeight,
                width: exitButtonWidth,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFA726), // Premium orange
                  borderRadius: BorderRadius.circular(exitButtonRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: screenWidth < 600
                          ? 8
                          : (screenWidth < 1400 ? 12 : 18),
                      offset: const Offset(0, 3),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onExitPressed,
                    borderRadius: BorderRadius.circular(exitButtonRadius),
                    child: Container(
                      height: exitButtonHeight,
                      width: exitButtonWidth,
                      child: Center(
                        child: ScalableText(
                          'Exit',
                          style: AppTextStyles.bodyMedium(context).copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: screenWidth < 400
                                ? 12
                                : screenWidth < 600
                                ? 13
                                : screenWidth < 900
                                ? 14
                                : screenWidth < 1400
                                ? 16
                                : 18,
                          ),
                          autoScale: false,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(
            height: elementSpacing * 0.6,
          ), // Tighter spacing for slim look
          // Title text with enhanced responsive sizing
          Center(
            child: ScalableText(
              title,
              style: AppTextStyles.headlineMedium(context).copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.darkText,
                fontSize: screenWidth < 400
                    ? 18
                    : screenWidth < 600
                    ? 20
                    : screenWidth < 900
                    ? 24
                    : screenWidth < 1400
                    ? 28
                    : 32,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              autoScale: false,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
