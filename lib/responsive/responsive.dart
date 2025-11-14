import 'package:flutter/widgets.dart';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';

class ResponsiveInfo {
  ResponsiveInfo({
    required this.screenWidth,
    required this.screenHeight,
    required this.physicalScreenWidth,
    required this.physicalScreenHeight,
    required this.isPortrait,
    required this.isLandscape,
    required this.breakpoint,
    required this.zoomFactor,
  });

  final double screenWidth;
  final double screenHeight;
  final double physicalScreenWidth;
  final double physicalScreenHeight;
  final bool isPortrait;
  final bool isLandscape;
  final ResponsiveBreakpoint breakpoint;
  final double zoomFactor;

  bool get isMobile => breakpoint == ResponsiveBreakpoint.mobile;
  bool get isTablet => breakpoint == ResponsiveBreakpoint.tablet;
  bool get isDesktop => breakpoint == ResponsiveBreakpoint.desktop;

  // More flexible responsive breakpoints
  bool get isVeryCompact => physicalScreenWidth < 320;
  bool get isCompact => physicalScreenWidth < 480;
  bool get isMedium => physicalScreenWidth >= 480 && physicalScreenWidth < 768;
  bool get isLarge => physicalScreenWidth >= 768 && physicalScreenWidth < 1200;
  bool get isXLarge => physicalScreenWidth >= 1200;

  // Zoom detection helpers
  bool get isZoomed => zoomFactor > 1.1;
  bool get isHighlyZoomed => zoomFactor > 1.5;
  bool get isExtremelyZoomed => zoomFactor > 2.0;

  // Flexible scaling factors for different screen sizes
  double get flexibleScale {
    if (isVeryCompact) return 0.85;
    if (isCompact) return 0.95;
    if (isMedium) return 1.0;
    if (isLarge) return 1.1;
    return 1.15; // XLarge
  }

  // Content scaling for zoom-independent sizing with flexible adjustment
  double get contentScale {
    final zoomFactor = physicalScreenWidth / screenWidth;
    // More granular zoom scaling
    if (zoomFactor > 2.0) return 0.75; // Very high zoom
    if (zoomFactor > 1.75) return 0.8; // High zoom
    if (zoomFactor > 1.5) return 0.85; // Medium-high zoom
    if (zoomFactor > 1.25) return 0.9; // Medium zoom
    return flexibleScale; // Normal zoom with device-based scaling
  }

  // Flexible dimension calculations
  double getFlexibleWidth(double percentage) {
    return (physicalScreenWidth * percentage / 100).clamp(
          physicalScreenWidth * 0.1,
          physicalScreenWidth * 0.95,
        ) *
        contentScale;
  }

  double getFlexibleHeight(double percentage) {
    return (physicalScreenHeight * percentage / 100).clamp(
          physicalScreenHeight * 0.05,
          physicalScreenHeight * 0.8,
        ) *
        contentScale;
  }

  double getFlexiblePadding({required double base, double? min, double? max}) {
    final calculated = base * contentScale * flexibleScale;
    return calculated.clamp(min ?? calculated * 0.5, max ?? calculated * 1.5);
  }

  double getFlexibleFontSize({required double base, double? min, double? max}) {
    final calculated = base * contentScale;
    return calculated.clamp(min ?? 12.0, max ?? base * 1.3);
  }

  // Zoom-aware adaptive scaling for different content types
  double getAdaptiveFontSize({
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    double baseSize;
    if (isMobile) {
      baseSize = mobile;
    } else if (isTablet) {
      baseSize = tablet;
    } else {
      baseSize = desktop;
    }
    return baseSize * contentScale;
  }

  double getAdaptiveSpacing({
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    double baseSpacing;
    if (isMobile) {
      baseSpacing = mobile;
    } else if (isTablet) {
      baseSpacing = tablet;
    } else {
      baseSpacing = desktop;
    }
    return baseSpacing * contentScale;
  }

  EdgeInsets getAdaptivePadding({
    required EdgeInsets mobile,
    required EdgeInsets tablet,
    required EdgeInsets desktop,
  }) {
    EdgeInsets basePadding;
    if (isMobile) {
      basePadding = mobile;
    } else if (isTablet) {
      basePadding = tablet;
    } else {
      basePadding = desktop;
    }
    return basePadding * contentScale;
  }
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
        final viewportWidth = media?.size.width ?? constraints.maxWidth;
        final viewportHeight = media?.size.height ?? constraints.maxHeight;

        // Get physical screen dimensions (zoom-independent)
        final physicalDimensions = _getPhysicalScreenDimensions();
        final physicalWidth = physicalDimensions['width'] ?? viewportWidth;
        final physicalHeight = physicalDimensions['height'] ?? viewportHeight;

        // Calculate zoom factor
        final zoomFactor = physicalWidth / viewportWidth;

        final orientation = physicalWidth > physicalHeight
            ? Orientation.landscape
            : Orientation.portrait;

        // Use physical dimensions for breakpoint calculation (zoom-independent)
        final breakpoint = _resolveBreakpoint(physicalWidth);

        final info = ResponsiveInfo(
          screenWidth: viewportWidth,
          screenHeight: viewportHeight,
          physicalScreenWidth: physicalWidth,
          physicalScreenHeight: physicalHeight,
          isPortrait: orientation == Orientation.portrait,
          isLandscape: orientation == Orientation.landscape,
          breakpoint: breakpoint,
          zoomFactor: zoomFactor,
        );

        return builder(context, info);
      },
    );
  }

  // Get physical screen dimensions independent of browser zoom
  Map<String, double> _getPhysicalScreenDimensions() {
    if (kIsWeb) {
      try {
        final screenWidth = html.window.screen?.width?.toDouble() ?? 0.0;
        final screenHeight = html.window.screen?.height?.toDouble() ?? 0.0;

        // Fallback to window.outerWidth/outerHeight if screen dimensions are not available
        final windowWidth = html.window.outerWidth.toDouble();
        final windowHeight = html.window.outerHeight.toDouble();

        return {
          'width': screenWidth > 0 ? screenWidth : windowWidth,
          'height': screenHeight > 0 ? screenHeight : windowHeight,
        };
      } catch (e) {
        // Fallback for any web platform issues
        return {'width': 1024.0, 'height': 768.0};
      }
    } else {
      // For non-web platforms, return default values
      return {'width': 1024.0, 'height': 768.0};
    }
  }

  ResponsiveBreakpoint _resolveBreakpoint(double physicalWidth) {
    if (physicalWidth < 600) return ResponsiveBreakpoint.mobile;
    if (physicalWidth < 1024) return ResponsiveBreakpoint.tablet;
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
