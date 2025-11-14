import 'package:flutter/material.dart';
import 'package:lesson_base_arignar/theme/app_colors.dart';
import 'package:lesson_base_arignar/theme/app_text_styles.dart';
import 'package:lesson_base_arignar/widgets/density/app_button.dart';
import 'package:lesson_base_arignar/widgets/density/scalable_text.dart';
import 'package:lesson_base_arignar/responsive/responsive.dart';

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
    return ResponsiveBuilder(
      builder: (context, responsive) {
        return _buildFlexibleLayout(context, responsive);
      },
    );
  }

  Widget _buildHeader(BuildContext context, ResponsiveInfo responsive) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.getFlexiblePadding(base: 16, min: 8, max: 24),
          vertical: responsive.getFlexiblePadding(base: 12, min: 6, max: 16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: ScalableText(
                    lessonTitle,
                    style: AppTextStyles.headlineMedium(
                      context,
                    ).copyWith(fontWeight: FontWeight.w600),
                    maxFontSize: responsive.getFlexibleFontSize(
                      base: 20,
                      max: 24,
                    ),
                    minFontSize: responsive.getFlexibleFontSize(
                      base: 16,
                      min: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: responsive.getFlexiblePadding(
                    base: 12,
                    min: 6,
                    max: 16,
                  ),
                ),
                AppButton(
                  label: 'Exit',
                  onPressed: onExitPressed,
                  expanded: false,
                  height: responsive.getFlexibleHeight(5).clamp(32, 48),
                ),
              ],
            ),
            SizedBox(
              height: responsive.getFlexiblePadding(base: 8, min: 4, max: 12),
            ),
            progressContent,
          ],
        ),
      ),
    );
  }

  Widget _buildFlexibleLayout(BuildContext context, ResponsiveInfo responsive) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: Column(
            children: [
              // Header with title and progress
              _buildHeader(context, responsive),

              // Main content area with flexible sizing - NO MAX WIDTH CONSTRAINTS
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.getFlexiblePadding(
                        base: 16,
                        min: 8,
                        max: 24,
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: responsive.getFlexiblePadding(base: 8),
                          ),

                          // Question card with flexible sizing
                          questionCard,

                          SizedBox(
                            height: responsive.getFlexiblePadding(
                              base: 16,
                              min: 8,
                              max: 24,
                            ),
                          ),

                          // Main content with flexible container
                          if (_shouldShowMainContent())
                            ..._buildMainContentContainer(responsive),

                          // Bottom spacing that adapts to screen height
                          SizedBox(
                            height: responsive
                                .getFlexibleHeight(8)
                                .clamp(32, 80),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom navigation
              _buildBottomNavigation(context, responsive),
            ],
          ),
        ),
      ),
    );
  }

  bool _shouldShowMainContent() {
    return !(mainContent is SizedBox &&
        (mainContent as SizedBox).width == 0.0 &&
        (mainContent as SizedBox).height == 0.0);
  }

  List<Widget> _buildMainContentContainer(ResponsiveInfo responsive) {
    return [
      SizedBox(
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(
              responsive.getFlexiblePadding(base: 16, min: 12, max: 20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: responsive.getFlexiblePadding(base: 4, max: 8),
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.all(
            responsive.getFlexiblePadding(base: 16, min: 12, max: 24),
          ),
          child: mainContent,
        ),
      ),
    ];
  }

  Widget _buildBottomNavigation(
    BuildContext context,
    ResponsiveInfo responsive,
  ) {
    final buttonSize = responsive.getFlexibleWidth(8).clamp(40.0, 56.0);
    final navPadding = responsive.getFlexiblePadding(base: 16, min: 8, max: 24);

    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: navPadding,
          vertical: responsive.getFlexiblePadding(base: 12, min: 8, max: 16),
        ),
        decoration: BoxDecoration(
          color: AppColors.lightYellowBackground,
          border: Border(
            top: BorderSide(color: AppColors.border.withOpacity(0.3), width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildIconButton(
              context: context,
              responsive: responsive,
              icon: Icons.home,
              onPressed: onExitPressed,
              size: buttonSize,
            ),
            _buildIconButton(
              context: context,
              responsive: responsive,
              icon: Icons.arrow_back,
              onPressed: onPrevPressed,
              size: buttonSize,
            ),
            _buildIconButton(
              context: context,
              responsive: responsive,
              icon: Icons.arrow_forward,
              onPressed: onNextPressed,
              size: buttonSize,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required BuildContext context,
    required ResponsiveInfo responsive,
    required IconData icon,
    required VoidCallback? onPressed,
    required double size,
  }) {
    final borderRadius = size * 0.25;
    final iconSize = (size * 0.5).clamp(16.0, 28.0);

    return Material(
      color: AppColors.headerOrange,
      borderRadius: BorderRadius.circular(borderRadius),
      elevation: 2,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: AppColors.white.withOpacity(0.2),
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          child: Icon(icon, color: AppColors.white, size: iconSize),
        ),
      ),
    );
  }
}
