import 'package:flutter/material.dart';
import 'package:lesson_base_arignar/theme/app_colors.dart';
import 'package:lesson_base_arignar/theme/app_text_styles.dart';
import 'package:lesson_base_arignar/widgets/density/scalable_text.dart';

class QuizOptions extends StatelessWidget {
  const QuizOptions({
    super.key,
    required this.options,
    required this.onOptionSelected,
    this.selectedIndex,
  });

  final List<String> options;
  final ValueChanged<int> onOptionSelected;
  final int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;

    // Responsive calculations for zoom support
    final isVeryCompact = screenWidth < 400;
    final isCompact = screenWidth < 600;

    // Dynamic grid configuration
    final crossAxisCount = isCompact ? 1 : 2;
    final childAspectRatio = isVeryCompact ? 3.0 : (isCompact ? 2.8 : 2.5);

    // Dynamic spacing based on viewport
    final spacing = (screenWidth * 0.03).clamp(12.0, 20.0);
    final borderRadius = (screenWidth * 0.05).clamp(20.0, 24.0);
    final horizontalPadding = (screenWidth * 0.04).clamp(16.0, 24.0);
    final verticalPadding = (screenWidth * 0.03).clamp(12.0, 18.0);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final isSelected = selectedIndex == index;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onOptionSelected(index),
            borderRadius: BorderRadius.circular(borderRadius),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFFFF3E0) // Light orange for selected
                    : Colors.white,
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFFF8F00) // Orange border for selected
                      : Colors.transparent,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? const Color(0xFFFF8F00).withOpacity(0.15)
                        : Colors.black.withOpacity(0.08),
                    blurRadius: isSelected ? 8 : 6,
                    offset: const Offset(0, 3),
                    spreadRadius: isSelected ? 2 : 1,
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Center(
                child: ScalableText(
                  options[index],
                  style: AppTextStyles.bodyLarge(context).copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? const Color(0xFFFF8F00) // Orange text for selected
                        : AppColors.darkText,
                    height: 1.3, // Better line height
                  ),
                  textAlign: TextAlign.center,
                  minFontSize: isVeryCompact ? 13 : (isCompact ? 14 : 15),
                  maxFontSize: isVeryCompact ? 15 : (isCompact ? 17 : 19),
                  autoScale: true,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
