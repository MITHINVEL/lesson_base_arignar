import 'package:flutter/material.dart';
import 'package:lesson_base_arignar/theme/app_colors.dart';
import 'package:lesson_base_arignar/theme/app_text_styles.dart';
import 'package:lesson_base_arignar/responsive/responsive.dart';

class QuizOptions extends StatelessWidget {
  const QuizOptions({
    super.key,
    required this.options,
    required this.onOptionSelected,
    this.selectedIndex,
    this.isAnswerCorrect,
    this.correctIndex,
  });

  final List<String> options;
  final ValueChanged<int> onOptionSelected;
  final int? selectedIndex;
  final bool? isAnswerCorrect;
  final int? correctIndex;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, responsive) {
        // Get screen dimensions for flexible sizing
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        // Fully responsive spacing - percentage based for all screens
        final spacing = screenWidth * 0.015; // 1.5% of screen width
        final borderRadius = screenWidth * 0.025; // 2.5% of screen width
        final verticalPadding = screenHeight * 0.008; // 0.8% of screen height

        // OPTIONS FONT SIZE - MUCH SMALLER than question
        final questionLength =
            80; // Average question length for consistent sizing
        double baseMaxFont;

        // Much smaller font sizes than question (question: 16-24, options: 12-18)
        if (questionLength > 160) {
          baseMaxFont = 12; // Much smaller than question (16)
        } else if (questionLength > 110) {
          baseMaxFont = 14; // Much smaller than question (18)
        } else if (questionLength > 80) {
          baseMaxFont = 15; // Much smaller than question (20)
        } else if (questionLength > 40) {
          baseMaxFont = 16; // Much smaller than question (22)
        } else {
          baseMaxFont = 17; // Much smaller than question (24)
        }

        // Apply same responsive scaling as question
        final isVeryCompact = screenWidth < 600;
        final isCompact = screenWidth < 900;

        final maxFont =
            baseMaxFont * (isVeryCompact ? 0.9 : (isCompact ? 0.95 : 1.1));
        final fontSize = maxFont.clamp(
          12.0,
          18.0,
        ); // Much smaller range (12-18) vs question (16-24)

        // Calculate dynamic height based on ALL options text content
        double maxRequiredHeight = 0;

        // Check each option to find the maximum height needed
        for (String option in options) {
          final textLength = option.length;
          final wordCount = option.split(' ').length;

          // Estimate lines needed for this option
          double estimatedLines = 1.0;
          if (textLength > 40 || wordCount > 6) {
            estimatedLines = 2.0; // Likely 2 lines
          }
          if (textLength > 80 || wordCount > 12) {
            estimatedLines = 3.0; // Likely 3 lines
          }

          // Calculate height needed for this option (responsive)
          final heightForOption =
              (fontSize * estimatedLines * 1.2) +
              (verticalPadding * 2) +
              (screenHeight * 0.01); // Add 1% screen height padding

          // Keep track of maximum height needed
          if (heightForOption > maxRequiredHeight) {
            maxRequiredHeight = heightForOption;
          }
        }

        // Use responsive height range - works on all screen sizes
        final containerHeight = maxRequiredHeight.clamp(
          screenHeight * 0.06, // Minimum 6% of screen height
          screenHeight * 0.15, // Maximum 15% of screen height
        );

        // Use ListView for mobile, Wrap for larger screens
        final isMobile = screenWidth < 600;

        // Mobile: Full width for ListView, Tablet/Desktop: 42% width for Wrap
        final containerWidth = isMobile
            ? screenWidth *
                  0.88 // Mobile: 88% width for ListView items
            : screenWidth * 0.42; // Tablet/Desktop: 42% width for Wrap items

        if (isMobile) {
          // Mobile: Use Column for vertical list layout
          return SizedBox(
            width: double.infinity,
            child: Column(
              children: List.generate(options.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < options.length - 1 ? spacing : 0,
                  ),
                  child: _buildOptionContainer(
                    context: context,
                    index: index,
                    containerWidth: containerWidth,
                    containerHeight: containerHeight,
                    screenWidth: screenWidth,
                    verticalPadding: verticalPadding,
                    borderRadius: borderRadius,
                    fontSize: fontSize,
                  ),
                );
              }),
            ),
          );
        } else {
          // Tablet/Desktop: Use Wrap for grid layout
          return SizedBox(
            width: double.infinity,
            child: Wrap(
              spacing: spacing,
              runSpacing: spacing,
              alignment: WrapAlignment.center,
              children: List.generate(options.length, (index) {
                return _buildOptionContainer(
                  context: context,
                  index: index,
                  containerWidth: containerWidth,
                  containerHeight: containerHeight,
                  screenWidth: screenWidth,
                  verticalPadding: verticalPadding,
                  borderRadius: borderRadius,
                  fontSize: fontSize,
                );
              }),
            ),
          );
        }
      },
    );
  }

  // Extract option container building logic to avoid duplication
  Widget _buildOptionContainer({
    required BuildContext context,
    required int index,
    required double containerWidth,
    required double containerHeight,
    required double screenWidth,
    required double verticalPadding,
    required double borderRadius,
    required double fontSize,
  }) {
    final isSelected = selectedIndex == index;

    // Determine feedback colors based on answer correctness
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    Color shadowColor;

    if (isSelected && isAnswerCorrect != null) {
      // Answer has been provided - show feedback colors
      if (isAnswerCorrect!) {
        // Correct answer - luxury green
        backgroundColor = const Color(0xFF4CAF50).withOpacity(0.1);
        borderColor = const Color(0xFF43A047);
        textColor = const Color(0xFF43A047);
        shadowColor = const Color(0xFF4CAF50).withOpacity(0.2);
      } else {
        // Wrong answer - premium red
        backgroundColor = const Color(0xFFE53935).withOpacity(0.1);
        borderColor = const Color(0xFFD32F2F);
        textColor = const Color(0xFFD32F2F);
        shadowColor = const Color(0xFFE53935).withOpacity(0.2);
      }
    } else if (isSelected) {
      // Selected but no feedback yet - default orange
      backgroundColor = const Color(0xFFFFF3E0);
      borderColor = const Color(0xFFFF8F00);
      textColor = const Color(0xFFFF8F00);
      shadowColor = const Color(0xFFFF8F00).withOpacity(0.15);
    } else {
      // Not selected - default white
      backgroundColor = const Color(0xFFFFFFFF);
      borderColor = Colors.grey.withOpacity(0.3);
      textColor = AppColors.darkText;
      shadowColor = Colors.black.withOpacity(0.06);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onOptionSelected(index),
        borderRadius: BorderRadius.circular(borderRadius),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          width: containerWidth, // Dynamic width based on screen size
          height: containerHeight, // Uniform height for all containers
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 2.5 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: screenWidth < 600 ? 8.0 : 12.0, // Enhanced shadow
                offset: const Offset(0, 3),
                spreadRadius: isSelected ? 1 : 0, // Spread for selected state
              ),
              // Additional subtle inner shadow for luxury effect
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                blurRadius: 1.0,
                offset: const Offset(0, 1),
                spreadRadius: 0,
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal:
                screenWidth * 0.025, // 2.5% of screen width - responsive
            vertical: verticalPadding, // Use responsive vertical padding
          ),
          child: Center(
            // Centered as requested
            child: Text(
              options[index],
              style: AppTextStyles.bodyLarge(context).copyWith(
                fontWeight: FontWeight.w600, // SAME as question (w600)
                color: textColor,
                height: 1.2, // Tighter for better fit
                fontSize: fontSize,
                letterSpacing:
                    0.2, // Slight letter spacing for Tamil readability
              ),
              textAlign:
                  TextAlign.left, // Left-aligned for natural multi-line reading
              maxLines: 3, // Allow up to 3 lines for better text accommodation
              overflow: TextOverflow.ellipsis, // Graceful overflow handling
              softWrap: true,
            ),
          ),
        ),
      ),
    );
  }
}
