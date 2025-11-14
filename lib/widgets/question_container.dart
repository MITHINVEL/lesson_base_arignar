import 'package:flutter/material.dart';
import 'package:lesson_base_arignar/theme/app_colors.dart';
import 'package:lesson_base_arignar/theme/app_text_styles.dart';
import 'package:lesson_base_arignar/widgets/density/scalable_text.dart';
import 'package:lesson_base_arignar/responsive/responsive.dart';

class QuestionContainer extends StatelessWidget {
  const QuestionContainer({
    super.key,
    required this.question,
    required this.onSpeakerTap,
  });

  final String question;
  final VoidCallback onSpeakerTap;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, responsive) {
        // Use physical screen width for zoom-independent calculations

        // Zoom-stable responsive calculations
        final isVeryCompact = responsive.isVeryCompact;
        final isCompact = responsive.isCompact;

        // Flexible sizing with responsive calculations
        final borderRadius = responsive.getFlexiblePadding(
          base: 16,
          min: 12,
          max: 20,
        );
        final shadowBlurRadius = responsive.getFlexiblePadding(
          base: 6,
          min: 3,
          max: 10,
        );
        final horizontalPadding = responsive.getFlexiblePadding(
          base: 20,
          min: 12,
          max: 28,
        );
        final verticalPadding = responsive.getFlexiblePadding(
          base: 16,
          min: 10,
          max: 22,
        );
        final speakerSize = responsive.getFlexibleWidth(10).clamp(36.0, 56.0);

        // Smart font sizing based on question length and screen size
        final questionLength = question.length;
        double baseMaxFont;

        // Dynamic font sizing based on content length
        if (questionLength > 160) {
          baseMaxFont = 20; // Very long text
        } else if (questionLength > 110) {
          baseMaxFont = 22; // Long text
        } else if (questionLength > 80) {
          baseMaxFont = 24; // Medium text
        } else if (questionLength > 40) {
          baseMaxFont = 26; // Short text
        } else {
          baseMaxFont = 28; // Very short text
        }

        // Apply responsive scaling
        final maxFont = responsive.getFlexibleFontSize(
          base: baseMaxFont,
          min: 16,
          max: isVeryCompact
              ? baseMaxFont * 0.9
              : (isCompact ? baseMaxFont * 0.95 : baseMaxFont * 1.1),
        );
        final minFont = responsive.getFlexibleFontSize(
          base: baseMaxFont - 4,
          min: 14,
          max: maxFont - 2,
        );

        return SizedBox(
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: shadowBlurRadius,
                  offset: const Offset(0, 3),
                  spreadRadius: 1,
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: Row(
              children: [
                // Question text (left-aligned)
                Expanded(
                  child: ScalableText(
                    question,
                    style: AppTextStyles.headlineMedium(context).copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkText,
                      height: 1.3, // Better line height for Tamil text
                    ),
                    textAlign: TextAlign.left,
                    minFontSize: minFont,
                    maxFontSize: maxFont,
                    autoScale: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                SizedBox(
                  width: responsive.getFlexiblePadding(
                    base: 14,
                    min: 8,
                    max: 20,
                  ),
                ),

                // Speaker icon (right side)
                Material(
                  color: const Color(0xFFFFF3E0), // Light orange background
                  borderRadius: BorderRadius.circular(speakerSize / 2),
                  child: InkWell(
                    onTap: onSpeakerTap,
                    borderRadius: BorderRadius.circular(speakerSize / 2),
                    child: Container(
                      width: speakerSize,
                      height: speakerSize,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.volume_up_rounded,
                        color: const Color(0xFFFF8F00), // Orange color
                        size: speakerSize * 0.6,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
