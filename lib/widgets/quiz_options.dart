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
        // Use physical screen dimensions for zoom-independent calculations

        // Flexible responsive calculations - NO CENTERING OR MAX WIDTH
        final containerHeight = responsive
            .getFlexibleHeight(
              responsive.isMobile ? 10 : (responsive.isTablet ? 12 : 11),
            )
            .clamp(70.0, 120.0);

        // Grid configuration based on breakpoints
        final crossAxisCount = responsive.isMobile ? 1 : 2;

        // Flexible padding and spacing
        final borderRadius = responsive.getFlexiblePadding(
          base: 22,
          min: 16,
          max: 28,
        );
        final horizontalPadding = responsive.getFlexiblePadding(
          base: 20,
          min: 16,
          max: 26,
        );
        final verticalPadding = responsive.getFlexiblePadding(
          base: 18,
          min: 14,
          max: 24,
        );
        final spacing = responsive.getFlexiblePadding(
          base: 16,
          min: 12,
          max: 20,
        );

        // Flexible font sizing
        final fontSize = responsive.getFlexibleFontSize(
          base: 18,
          min: 16,
          max: 22,
        );

        return SizedBox(
          width: double.infinity,
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
                    width: double.infinity,
                    height: containerHeight,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(borderRadius),
                      border: Border.all(color: borderColor, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor,
                          blurRadius: responsive.getFlexiblePadding(
                            base: 12,
                            min: 8,
                            max: 16,
                          ),
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
                          fontWeight: responsive.isMobile
                              ? FontWeight.w500
                              : (responsive.isTablet
                                    ? FontWeight.w600
                                    : FontWeight.w600),
                          color:
                              textColor, // Use dynamic text color for feedback
                          height: 1.4, // Premium line height
                          fontSize: fontSize, // Use responsive font size
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
        );
      },
    );
  }
}
