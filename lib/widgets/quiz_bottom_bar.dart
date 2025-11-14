import 'package:flutter/material.dart';
import 'package:lesson_base_arignar/responsive/responsive.dart';

class QuizBottomBar extends StatelessWidget {
  const QuizBottomBar({
    super.key,
    required this.onHomePressed,
    required this.onBackPressed,
    required this.onNextPressed,
    this.canGoBack = true,
    this.canGoNext = true,
  });

  final VoidCallback onHomePressed;
  final VoidCallback onBackPressed;
  final VoidCallback onNextPressed;
  final bool canGoBack;
  final bool canGoNext;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, responsive) {
        // Use physical screen width for zoom-independent calculations
        final screenWidth = responsive.physicalScreenWidth;

        // ZOOM-STABLE: Accessibility-first button sizing with content scaling
        final buttonSize =
            (screenWidth < 600
                ? 44.0 // Mobile: increased from 36 to 44
                : screenWidth < 1024
                ? 50.0 // Tablet: increased from 42 to 50
                : 56.0) *
            responsive.contentScale; // Desktop: increased from 48 to 56

        // Enhanced padding with zoom-aware scaling
        final horizontalPadding =
            (screenWidth < 600
                ? 20.0 // Mobile: increased from 16 to 20
                : screenWidth < 1024
                ? 28.0 // Tablet: increased from 24 to 28
                : 36.0) *
            responsive.contentScale; // Desktop: increased from 32 to 36

        return SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical:
                  12.0 *
                  responsive
                      .contentScale, // Increased from 8.0 for better touch targets
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFFFF8E1), // Soft cream background
              boxShadow: [
                BoxShadow(
                  color: Color(0x15000000),
                  blurRadius: 12,
                  offset: Offset(0, -3),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Home button
                  _buildNavigationButton(
                    icon: Icons.home_rounded,
                    onPressed: onHomePressed,
                    buttonSize: buttonSize,
                    isEnabled: true,
                    buttonType: 'home',
                  ),

                  // Back button
                  _buildNavigationButton(
                    icon: Icons.arrow_back_rounded,
                    onPressed: canGoBack ? onBackPressed : null,
                    buttonSize: buttonSize,
                    isEnabled: canGoBack,
                    buttonType: 'back',
                  ),

                  // Next button
                  _buildNavigationButton(
                    icon: Icons.arrow_forward_rounded,
                    onPressed: canGoNext ? onNextPressed : null,
                    buttonSize: buttonSize,
                    isEnabled: canGoNext,
                    buttonType: 'next',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required double buttonSize,
    required bool isEnabled,
    String buttonType = 'default',
  }) {
    // Enhanced button color scheme - NO grey for back button
    Color buttonColor;
    Color shadowColor;

    if (!isEnabled) {
      buttonColor = const Color(
        0xFFE0E0E0,
      ); // Disabled grey only when truly disabled
      shadowColor = Colors.black.withOpacity(0.1);
    } else if (buttonType == 'back') {
      buttonColor = const Color(
        0xFFFFB74D,
      ); // Soft muted orange for back (NOT grey)
      shadowColor = const Color(0xFFFFB74D).withOpacity(0.2);
    } else {
      buttonColor = const Color(0xFFFFA726); // Bright orange for home/next
      shadowColor = const Color(0xFFFFA726).withOpacity(0.25);
    }

    // Fixed shape consistency: border radius proportional to button size
    // This maintains the same visual shape ratio across all device sizes
    final borderRadius =
        buttonSize * 0.42; // Consistent 42% ratio for stable shape

    return Material(
      color: buttonColor,
      borderRadius: BorderRadius.circular(borderRadius),
      elevation: isEnabled ? 4 : 1, // Reduced elevation for embedded view
      shadowColor: shadowColor,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          width: buttonSize,
          height: buttonSize,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: isEnabled
                ? Colors
                      .white // All active buttons get white icons (including back)
                : const Color(0xFF9E9E9E),
            size:
                buttonSize *
                0.48, // Slightly increased for better visibility in compact size
          ),
        ),
      ),
    );
  }
}
