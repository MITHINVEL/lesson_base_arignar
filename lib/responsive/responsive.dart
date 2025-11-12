import 'package:flutter/widgets.dart';

class ResponsiveInfo {
  ResponsiveInfo({
    required this.screenWidth,
    required this.screenHeight,
    required this.isPortrait,
    required this.isLandscape,
    required this.breakpoint,
  });

  final double screenWidth;
  final double screenHeight;
  final bool isPortrait;
  final bool isLandscape;
  final ResponsiveBreakpoint breakpoint;

  bool get isMobile => breakpoint == ResponsiveBreakpoint.mobile;
  bool get isTablet => breakpoint == ResponsiveBreakpoint.tablet;
  bool get isDesktop => breakpoint == ResponsiveBreakpoint.desktop;
}

enum ResponsiveBreakpoint { mobile, tablet, desktop }

typedef ResponsiveWidgetBuilder =
    Widget Function(BuildContext context, ResponsiveInfo info);

class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({super.key, required this.builder});

  final ResponsiveWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final media = MediaQuery.maybeOf(context);
        final width = media?.size.width ?? constraints.maxWidth;
        final height = media?.size.height ?? constraints.maxHeight;
        final orientation =
            media?.orientation ??
            (width > height ? Orientation.landscape : Orientation.portrait);

        final breakpoint = _resolveBreakpoint(width);

        final info = ResponsiveInfo(
          screenWidth: width,
          screenHeight: height,
          isPortrait: orientation == Orientation.portrait,
          isLandscape: orientation == Orientation.landscape,
          breakpoint: breakpoint,
        );

        return builder(context, info);
      },
    );
  }

  ResponsiveBreakpoint _resolveBreakpoint(double width) {
    if (width < 768) return ResponsiveBreakpoint.mobile;
    if (width < 1200) return ResponsiveBreakpoint.tablet;
    return ResponsiveBreakpoint.desktop;
  }
}

class ResponsiveContainer extends StatelessWidget {
  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxContentWidth = 960,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.alignment = Alignment.topCenter,
  });

  final Widget child;
  final double maxContentWidth;
  final EdgeInsetsGeometry padding;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxContentWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
