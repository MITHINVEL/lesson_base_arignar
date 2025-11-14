import 'package:flutter/material.dart';
import 'package:lesson_base_arignar/theme/app_colors.dart';
import 'package:lesson_base_arignar/theme/app_text_styles.dart';

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
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final screenHeight = media.size.height;

    // PRODUCTION-SAFE: Auto-scale factors for extremely small screens
    double fontScale = 1.0;
    double spacingScale = 1.0;

    if (screenWidth < 350) {
      fontScale = (screenWidth / 350).clamp(0.7, 1.0);
      spacingScale = (screenWidth / 350).clamp(0.6, 1.0);
    }

    // Enhanced responsive breakpoints for better medium-screen support
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;

    // Responsive container width calculations with better medium-screen support and safe constraints
    double containerWidth;
    if (isMobile) {
      containerWidth = (screenWidth * 0.90 * spacingScale).clamp(
        280.0,
        double.infinity,
      );
    } else if (isTablet) {
      containerWidth = screenWidth * 0.75; // Tablet: 75% for balanced layout
    } else {
      containerWidth =
          screenWidth * 0.60; // Desktop: 60% for optimal readability
    }

    // Grid configuration with proper medium-screen handling
    final crossAxisCount = isMobile ? 1 : 2;

    // Enhanced height scaling for medium screens
    double containerHeight;
    if (isMobile) {
      containerHeight = 75.0; // Mobile: compact but readable
    } else if (isTablet) {
      containerHeight = 95.0; // Tablet: increased height for better proportions
    } else {
      containerHeight = 85.0; // Desktop: balanced height
    }

    // Enhanced styling with responsive padding
    const borderRadius = 22.0;

    double horizontalPadding;
    double verticalPadding;
    if (isMobile) {
      horizontalPadding = 16.0;
      verticalPadding = 14.0;
    } else if (isTablet) {
      horizontalPadding = 20.0; // Increased for medium screens
      verticalPadding = 18.0; // Increased for better proportions
    } else {
      horizontalPadding = 18.0;
      verticalPadding = 16.0;
    }

    // Responsive spacing
    double spacing;
    if (isMobile) {
      spacing = 14.0;
    } else if (isTablet) {
      spacing = 18.0; // Increased spacing for medium screens
    } else {
      spacing = 16.0;
    }

    // Enhanced font sizing for medium screens
    double fontSize;
    if (isMobile) {
      fontSize = 15.0;
    } else if (isTablet) {
      fontSize = 16.5; // Optimal size for tablet readability
    } else {
      fontSize = 17.0;
    }

    return Center(
      child: SizedBox(
        width: containerWidth,
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisExtent: containerHeight, // Responsive height
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
          ),
          itemCount: options.length,
          itemBuilder: (context, index) {
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
              borderColor = Colors.transparent;
              textColor = AppColors.darkText;
              shadowColor = Colors.black.withOpacity(0.08);
            }

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onOptionSelected(index),
                borderRadius: BorderRadius.circular(borderRadius),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  height: containerHeight,
                  constraints: BoxConstraints(
                    minWidth: isMobile ? 250.0 : 220.0,
                    maxWidth: double.infinity,
                  ),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(borderRadius),
                    border: Border.all(color: borderColor, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor,
                        blurRadius: isTablet ? 16 : 12,
                        offset: const Offset(0, 3),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      options[index],
                      style: AppTextStyles.bodyLarge(context).copyWith(
                        fontWeight: isMobile
                            ? FontWeight.w500
                            : (isTablet ? FontWeight.w600 : FontWeight.w600),
                        color: textColor, // Use dynamic text color for feedback
                        height: 1.4, // Premium line height
                        fontSize: (fontSize * fontScale).clamp(
                          12.0,
                          20.0,
                        ), // Safe responsive sizing
                      ),
                      textAlign: TextAlign.left,
                      maxLines: null,
                      overflow: TextOverflow.visible,
                      softWrap: true,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
