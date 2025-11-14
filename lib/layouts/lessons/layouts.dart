import 'package:flutter/material.dart';
import 'package:lesson_base_arignar/theme/app_colors.dart';
import 'package:lesson_base_arignar/theme/app_text_styles.dart';
import 'package:lesson_base_arignar/widgets/density/app_button.dart';
import 'package:lesson_base_arignar/widgets/density/scalable_text.dart';

class AdaptiveLessonLayout extends StatelessWidget {
  const AdaptiveLessonLayout({
    super.key,
    required this.questionCard,
    required this.mainContent,
    required this.progressContent,
    required this.lessonTitle,
    this.onExitPressed,
    this.onPrevPressed,
    this.onNextPressed,
    this.onJumpToQuestion,
  });

  final Widget questionCard;
  final Widget mainContent;
  final Widget progressContent;
  final String lessonTitle;
  final VoidCallback? onExitPressed;
  final VoidCallback? onPrevPressed;
  final VoidCallback? onNextPressed;
  final VoidCallback? onJumpToQuestion;

  @override
  Widget build(BuildContext context) {
    // Always use mobile-first single column layout
    return _buildMobileLayout(context);
  }

  Widget _buildHeader(BuildContext context) {
    final textScaleFactor = MediaQuery.textScalerOf(context).scale(1.0);
    return Padding(
      padding: EdgeInsets.only(
        top: 8 * textScaleFactor,
        left: 12 * textScaleFactor,
        right: 12 * textScaleFactor,
        bottom: 6 * textScaleFactor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ScalableText(
                  lessonTitle,
                  style: AppTextStyles.headlineMedium(
                    context,
                  ).copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                  maxFontSize: 20,
                  minFontSize: 16,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 8 * textScaleFactor),
              AppButton(
                label: 'Exit',
                onPressed: onExitPressed,
                expanded: false,
                height: 36 * textScaleFactor,
              ),
            ],
          ),
          SizedBox(height: 6 * textScaleFactor),
          progressContent,
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isCompact = screenWidth < 420;
        final textScaleFactor = MediaQuery.textScalerOf(context).scale(1.0);

        return Column(
          children: [
            // Header with title and progress bar
            Flexible(flex: 0, child: _buildHeader(context)),

            // Main content area
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: (isCompact ? 12 : 16) * textScaleFactor,
                  vertical: 4 * textScaleFactor,
                ),
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    questionCard,
                    SizedBox(height: 4 * textScaleFactor),
                    // Show mainContent if it exists
                    if (!(mainContent is SizedBox &&
                        (mainContent as SizedBox).width == 0.0 &&
                        (mainContent as SizedBox).height == 0.0)) ...[
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(
                            16 * textScaleFactor,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(
                            (isCompact ? 8 : 12) * textScaleFactor,
                          ),
                          child: mainContent,
                        ),
                      ),
                      SizedBox(height: 4 * textScaleFactor),
                    ],
                    // Add spacing for bottom navigation
                    SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                  ],
                ),
              ),
            ),

            // Bottom navigation with icon buttons
            Flexible(flex: 0, child: _buildBottomNavigation(context)),
          ],
        );
      },
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return LayoutBuilder(
      builder: (context, navConstraints) {
        final screenWidth = navConstraints.maxWidth;
        final screenHeight = navConstraints.maxHeight;
        final textScaleFactor = MediaQuery.textScalerOf(context).scale(1.0);

        // Calculate button size based on both width and height with text scaling
        final buttonSize = (screenWidth * 0.07 * textScaleFactor).clamp(
          32.0,
          44.0 * textScaleFactor,
        );
        final navPadding = (screenWidth * 0.02 * textScaleFactor).clamp(
          8.0,
          16.0 * textScaleFactor,
        );
        final verticalPadding = (screenHeight * 0.008 * textScaleFactor).clamp(
          4.0,
          10.0 * textScaleFactor,
        );

        return SafeArea(
          child: Container(
            width: screenWidth,
            padding: EdgeInsets.symmetric(
              horizontal: navPadding,
              vertical: verticalPadding,
            ),
            decoration: BoxDecoration(
              color: AppColors.lightYellowBackground,
              border: Border(
                top: BorderSide(
                  color: AppColors.border.withOpacity(0.3),
                  width: 0.8,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Center(
                    child: _buildIconButton(
                      context: context,
                      icon: Icons.home,
                      onPressed: onExitPressed,
                      size: buttonSize,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: _buildIconButton(
                      context: context,
                      icon: Icons.arrow_back,
                      onPressed: onPrevPressed,
                      size: buttonSize,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: _buildIconButton(
                      context: context,
                      icon: Icons.arrow_forward,
                      onPressed: onNextPressed,
                      size: buttonSize,
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

  Widget _buildIconButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback? onPressed,
    required double size,
  }) {
    final textScaleFactor = MediaQuery.textScalerOf(context).scale(1.0);
    return Material(
      color: AppColors.headerOrange,
      borderRadius: BorderRadius.circular(size * 0.2),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(size * 0.2),
        child: Container(
          width: size,
          height: size,
          constraints: BoxConstraints(
            minWidth: 32 * textScaleFactor,
            minHeight: 32 * textScaleFactor,
            maxWidth: 48 * textScaleFactor,
            maxHeight: 48 * textScaleFactor,
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: AppColors.white,
            size: (size * 0.45 * textScaleFactor).clamp(
              14.0 * textScaleFactor,
              22.0 * textScaleFactor,
            ),
          ),
        ),
      ),
    );
  }
}
