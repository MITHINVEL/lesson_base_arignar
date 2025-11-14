import 'package:flutter/material.dart';
import 'package:lesson_base_arignar/theme/app_colors.dart';
import 'package:lesson_base_arignar/theme/app_text_styles.dart';
import 'package:lesson_base_arignar/widgets/density/scalable_text.dart';
import 'package:lesson_base_arignar/responsive/responsive.dart';

class QuizHeader extends StatelessWidget {
  const QuizHeader({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.progressPercentage,
    required this.title,
  });

  final int currentQuestion;
  final int totalQuestions;
  final double progressPercentage;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, responsive) {
        // Use physical screen width for zoom-independent calculations
        final screenWidth = responsive.physicalScreenWidth;

        // ZOOM-STABLE: Base scaling on physical dimensions, not viewport
        double fontScale = 1.0;
        double spacingScale = 1.0;

        if (screenWidth < 350) {
          fontScale = (screenWidth / 350).clamp(0.75, 1.0);
          spacingScale = (screenWidth / 350).clamp(0.6, 1.0);
        }

        // Apply additional content scaling for high zoom levels
        fontScale *= responsive.contentScale;
        spacingScale *= responsive.contentScale;

        // Safe padding with minimum constraints
        final horizontalPadding =
            ((screenWidth < 400
                        ? 16.0
                        : screenWidth < 600
                        ? 20.0
                        : screenWidth < 900
                        ? 24.0
                        : screenWidth < 1400
                        ? 28.0
                        : 32.0) *
                    spacingScale)
                .clamp(8.0, 50.0);

        // Very compact vertical spacing with overflow protection
        final verticalPadding =
            ((screenWidth < 400
                        ? 6.0
                        : screenWidth < 600
                        ? 8.0
                        : screenWidth < 900
                        ? 10.0
                        : screenWidth < 1400
                        ? 12.0
                        : 14.0) *
                    spacingScale)
                .clamp(4.0, 20.0);

        // Slim modern progress bar height with safe minimum
        final progressHeight =
            (screenWidth < 400
                    ? 4.0 // Mobile: ultra-slim
                    : screenWidth < 600
                    ? 4.5 // Tablet: slim
                    : screenWidth < 900
                    ? 5.0 // Laptop: moderate
                    : screenWidth < 1400
                    ? 5.5 // Desktop: slightly thicker
                    : 6.0)
                .clamp(3.0, 8.0); // Safe bounds

        // Element spacing for clean layout with safe scaling
        final elementSpacing =
            ((screenWidth < 400
                        ? 12.0
                        : screenWidth < 600
                        ? 14.0
                        : screenWidth < 900
                        ? 16.0
                        : screenWidth < 1400
                        ? 18.0
                        : 20.0) *
                    spacingScale)
                .clamp(8.0, 30.0);

        return SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.only(
              left: horizontalPadding,
              right: horizontalPadding,
              top: verticalPadding,
              bottom: verticalPadding,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF8EF), // Premium cream background
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title text first - HEADLINE ABOVE PROGRESS BAR
                ScalableText(
                  title,
                  style: AppTextStyles.headlineMedium(context).copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkText,
                    fontSize:
                        ((screenWidth < 400
                                    ? 16
                                    : screenWidth < 600
                                    ? 18
                                    : screenWidth < 900
                                    ? 20
                                    : screenWidth < 1400
                                    ? 22
                                    : 24) *
                                fontScale)
                            .clamp(12.0, 28.0),
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                  autoScale: false,
                  maxLines: 3, // Increased for overflow protection
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: elementSpacing * 0.6),

                // Progress row: Question counter (left), progress bar (center), percentage (right)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left: Question counter with padding for spacing
                    Flexible(
                      child: ScalableText(
                        '$currentQuestion/$totalQuestions',
                        style: AppTextStyles.bodyMedium(context).copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkText,
                          fontSize:
                              ((screenWidth < 400
                                          ? 13
                                          : screenWidth < 600
                                          ? 14
                                          : screenWidth < 900
                                          ? 15
                                          : screenWidth < 1400
                                          ? 16
                                          : 17) *
                                      fontScale)
                                  .clamp(10.0, 20.0),
                        ),
                        autoScale: false,
                      ),
                    ),

                    // Center: Slim gradient progress bar - FULL WIDTH
                    Expanded(
                      flex: 4, // Give maximum space to progress bar
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal:
                              elementSpacing *
                              0.2, // Minimal margin for full width
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 100.0, // Increased for better coverage
                        ),
                        child: _buildSlimProgressBar(progressHeight),
                      ),
                    ),

                    // Right: Percentage text with padding for spacing
                    Flexible(
                      child: ScalableText(
                        '${progressPercentage.toInt()}%',
                        style: AppTextStyles.bodyMedium(context).copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkText,
                          fontSize:
                              ((screenWidth < 400
                                          ? 13
                                          : screenWidth < 600
                                          ? 14
                                          : screenWidth < 900
                                          ? 15
                                          : screenWidth < 1400
                                          ? 16
                                          : 17) *
                                      fontScale)
                                  .clamp(10.0, 20.0),
                        ),
                        autoScale: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Slim modern gradient progress bar widget
  Widget _buildSlimProgressBar(double height) {
    // Calculate actual progress as a value between 0.0 and 1.0
    final progressValue = progressPercentage / 100;

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height * 0.5),
        color: const Color(0xFFE0E0E0), // Soft grey background for entire bar
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height * 0.5),
        child: Stack(
          children: [
            // Background (unfilled portion) - stays grey
            Container(
              width: double.infinity,
              height: height,
              color: const Color(0xFFE0E0E0),
            ),
            // Gradient fill - ONLY for the filled portion
            AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
              height: height,
              // Width is ONLY the progress percentage of the total width
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor:
                    progressValue, // This controls the actual fill width
                child: Container(
                  height: height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(height * 0.5),
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFFFFE082), // Light Yellow
                        Color(0xFFFFCA28), // Medium Yellow
                        Color(0xFFFFA000), // Deep Orange
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
