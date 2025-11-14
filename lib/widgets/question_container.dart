import 'package:flutter/material.dart';
import 'package:lesson_base_arignar/theme/app_colors.dart';
import 'package:lesson_base_arignar/theme/app_text_styles.dart';
import 'package:lesson_base_arignar/widgets/density/scalable_text.dart';

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
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;

    // Responsive calculations for zoom support
    final isVeryCompact = screenWidth < 400;
    final isCompact = screenWidth < 600;

    // Dynamic sizing based on viewport
    final borderRadius = (screenWidth * 0.04).clamp(18.0, 22.0);
    final shadowBlurRadius = (screenWidth * 0.015).clamp(6.0, 10.0);
    final horizontalPadding = (screenWidth * 0.05).clamp(20.0, 28.0);
    final verticalPadding = (screenWidth * 0.04).clamp(16.0, 24.0);
    final speakerSize = (screenWidth * 0.08).clamp(32.0, 48.0);

    // Question text font sizing based on length and viewport
    final questionLength = question.length;
    double maxFont;
    if (questionLength > 160) {
      maxFont = isVeryCompact ? 16 : (isCompact ? 18 : 20);
    } else if (questionLength > 110) {
      maxFont = isVeryCompact ? 18 : (isCompact ? 20 : 22);
    } else if (questionLength > 80) {
      maxFont = isVeryCompact ? 20 : (isCompact ? 22 : 24);
    } else {
      maxFont = isVeryCompact ? 22 : (isCompact ? 24 : 26);
    }
    final minFont = (maxFont - (isVeryCompact ? 4 : 6)).clamp(14.0, maxFont);

    return Container(
      width: double.infinity,
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

          SizedBox(width: isCompact ? 12 : 16),

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
    );
  }
}
