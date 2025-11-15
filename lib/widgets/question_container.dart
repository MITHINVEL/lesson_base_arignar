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
          base: 10, // Further reduced from 12
          min: 6,
          max: 14, // Reduced from 16
        );
        final verticalPadding = responsive.getFlexiblePadding(
          base: 10, // INCREASED from 4 to 10 for more height
          min: 6, // INCREASED from 2 to 6 for mobile
          max: 14, // INCREASED from 6 to 14 for desktop
        );

        // Smart font sizing based on question length and container height
        final questionLength = question.length;
        double baseMaxFont;

        // Smaller, more refined font sizing for better container fit
        if (questionLength > 160) {
          baseMaxFont = 16; // Very long text - smaller font
        } else if (questionLength > 110) {
          baseMaxFont = 18; // Long text
        } else if (questionLength > 80) {
          baseMaxFont = 20; // Medium text
        } else if (questionLength > 40) {
          baseMaxFont = 22; // Short text
        } else {
          baseMaxFont = 24; // Very short text
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

        // Speaker icon size based on font size - slightly bigger with padding
        final speakerSize =
            maxFont + 16; // Font size + more padding for bigger container
        final actualIconSize = maxFont * 1.2; // Icon 20% BIGGER than font size

        return SizedBox(
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: shadowBlurRadius,
                  offset: const Offset(0, 2),
                  spreadRadius: 0,
                ),
                // Subtle inner highlight for luxury feel
                BoxShadow(
                  color: Colors.white.withOpacity(0.8),
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                  spreadRadius: 0,
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
                      height: 1.25, // Optimized line height for Tamil
                      letterSpacing:
                          0.1, // Slight letter spacing for readability
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
                        size:
                            actualIconSize, // Use calculated responsive icon size
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
