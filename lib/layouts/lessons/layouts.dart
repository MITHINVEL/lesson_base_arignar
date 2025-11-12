import 'package:flutter/material.dart';
import 'package:lesson_base_arignar/responsive/responsive.dart';
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
    return ResponsiveBuilder(
      builder: (context, info) {
        final content = info.isDesktop || info.isTablet
            ? _buildWideLayout(context, info)
            : _buildNarrowLayout(context, info);

        return content;
      },
    );
  }

  Widget _buildHeader(BuildContext context, ResponsiveInfo info) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScalableText(
                  lessonTitle,
                  style: AppTextStyles.headlineMedium(context),
                  maxFontSize: info.isDesktop ? 36 : 28,
                  minFontSize: 18,
                ),
                const SizedBox(height: 6),
                ScalableText(
                  'Stay on track and complete the lesson at your own pace.',
                  style: AppTextStyles.bodyMedium(context),
                  maxFontSize: 18,
                  minFontSize: 13,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          AppButton(label: 'Exit', onPressed: onExitPressed, expanded: false),
        ],
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context, ResponsiveInfo info) {
    return Column(
      children: [
        _buildHeader(context, info),
        const Divider(height: 1, thickness: 1, color: AppColors.border),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      questionCard,
                      const SizedBox(height: 16),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: mainContent,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildNavigationRow(context),
                    ],
                  ),
                ),
              ),
              Container(
                width: info.isDesktop ? 280 : 240,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  border: Border(left: BorderSide(color: AppColors.border)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ScalableText(
                        'Progress',
                        style: AppTextStyles.titleMedium(context),
                        maxFontSize: 24,
                        minFontSize: 16,
                      ),
                      const SizedBox(height: 12),
                      Expanded(child: progressContent),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(BuildContext context, ResponsiveInfo info) {
    final isCompactWidth = info.screenWidth < 420;
    final shouldScroll =
        info.screenHeight < 760 ||
        (info.screenWidth < 380 && info.screenHeight < 840);
    if (shouldScroll) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context, info),
            const Divider(height: 1, thickness: 1, color: AppColors.border),
            SizedBox(height: isCompactWidth ? 10 : 14),
            questionCard,
            SizedBox(height: isCompactWidth ? 10 : 14),
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(isCompactWidth ? 12 : 16),
                child: mainContent,
              ),
            ),
            SizedBox(height: isCompactWidth ? 10 : 14),
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(isCompactWidth ? 12 : 16),
                child: progressContent,
              ),
            ),
            SizedBox(height: isCompactWidth ? 10 : 14),
            _buildNavigationRow(context),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context, info),
          const Divider(height: 1, thickness: 1, color: AppColors.border),
          SizedBox(height: isCompactWidth ? 8 : 12),
          questionCard,
          SizedBox(height: isCompactWidth ? 8 : 12),
          Flexible(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(isCompactWidth ? 12 : 16),
                child: mainContent,
              ),
            ),
          ),
          SizedBox(height: isCompactWidth ? 8 : 12),
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(isCompactWidth ? 12 : 16),
              child: progressContent,
            ),
          ),
          SizedBox(height: isCompactWidth ? 8 : 12),
          _buildNavigationRow(context),
        ],
      ),
    );
  }

  Widget _buildNavigationRow(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 680;
        final buttonHeight = constraints.maxWidth < 420 ? 34.0 : 40.0;
        final buttons = [
          AppButton(
            label: 'Previous',
            onPressed: onPrevPressed,
            height: buttonHeight,
          ),
          AppButton(
            label: 'Jump to Question',
            onPressed: onJumpToQuestion,
            height: buttonHeight,
          ),
          AppButton(
            label: 'Next',
            onPressed: onNextPressed,
            height: buttonHeight,
          ),
        ];

        if (isCompact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < buttons.length; i++) ...[
                buttons[i],
                if (i != buttons.length - 1) const SizedBox(height: 12),
              ],
            ],
          );
        }

        return Row(
          children: [
            for (var i = 0; i < buttons.length; i++) ...[
              Expanded(child: buttons[i]),
              if (i != buttons.length - 1) const SizedBox(width: 16),
            ],
          ],
        );
      },
    );
  }
}
