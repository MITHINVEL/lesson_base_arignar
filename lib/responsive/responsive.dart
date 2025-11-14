import 'package:flutter/widgets.dart';
import 'dart:math' as math;

class ResponsiveInfo {
  ResponsiveInfo({
    required this.screenWidth,
    required this.screenHeight,
    required this.isPortrait,
    required this.isLandscape,
    required this.breakpoint,
    required this.customScaleFactor,
    required this.detectedZoomLevel,
    required this.devicePixelRatio,
  });

  final double screenWidth;
  final double screenHeight;
  final bool isPortrait;
  final bool isLandscape;
  final ResponsiveBreakpoint breakpoint;
  final double customScaleFactor;
  final double detectedZoomLevel;
  final double devicePixelRatio;

  bool get isMobile => breakpoint == ResponsiveBreakpoint.mobile;
  bool get isTablet => breakpoint == ResponsiveBreakpoint.tablet;
  bool get isDesktop => breakpoint == ResponsiveBreakpoint.desktop;

  // Automatic compact mode detection for extreme zoom
  bool get isCompactMode => customScaleFactor < 0.7 || detectedZoomLevel >= 2.0;
  bool get isSuperCompactMode =>
      customScaleFactor < 0.5 || detectedZoomLevel >= 3.0;

  // Custom scaling methods - ALL use the custom scale factor
  double get fontScale => customScaleFactor;
  double get spacingScale => customScaleFactor;
  double get componentScale => customScaleFactor;
  double get borderScale => customScaleFactor;
  double get imageScale => customScaleFactor;
  double get paddingScale => customScaleFactor;
  double get marginScale => customScaleFactor;

  // Enhanced scaling methods for extreme zoom
  double get compactFontScale =>
      isCompactMode ? customScaleFactor * 0.85 : customScaleFactor;
  double get compactSpacingScale =>
      isCompactMode ? customScaleFactor * 0.7 : customScaleFactor;
  double get compactImageScale =>
      isCompactMode ? customScaleFactor * 0.6 : customScaleFactor;

  // Helper methods for applying scaling
  double scaleFont(double baseFontSize) => baseFontSize * compactFontScale;
  double scaleSpacing(double baseSpacing) => baseSpacing * compactSpacingScale;
  double scaleComponent(double baseSize) => baseSize * componentScale;
  double scaleBorder(double borderRadius) => borderRadius * borderScale;
  double scaleImage(double imageSize) => imageSize * compactImageScale;
  EdgeInsets scalePadding(EdgeInsets basePadding) => EdgeInsets.fromLTRB(
    basePadding.left * compactSpacingScale,
    basePadding.top * compactSpacingScale,
    basePadding.right * compactSpacingScale,
    basePadding.bottom * compactSpacingScale,
  );
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

        // Get device pixel ratio for zoom detection
        final devicePixelRatio = media?.devicePixelRatio ?? 1.0;

        // Calculate custom scale factor using your scaling table
        final zoomData = _calculateCustomZoomScale(width, devicePixelRatio);
        final detectedZoom = zoomData['detectedZoom'] as double;
        final customScale = zoomData['customScale'] as double;

        // Breakpoint resolution based on ACTUAL screen width (not affected by zoom)
        final breakpoint = _resolveBreakpoint(width);

        final info = ResponsiveInfo(
          screenWidth: width,
          screenHeight: height,
          isPortrait: orientation == Orientation.portrait,
          isLandscape: orientation == Orientation.landscape,
          breakpoint: breakpoint,
          customScaleFactor: customScale,
          detectedZoomLevel: detectedZoom,
          devicePixelRatio: devicePixelRatio,
        );

        return builder(context, info);
      },
    );
  }

  // CUSTOM ZOOM-NORMALIZATION ENGINE WITH FULL FLEX SHRINK
  Map<String, double> _calculateCustomZoomScale(
    double screenWidth,
    double devicePixelRatio,
  ) {
    // Base reference dimensions for zoom detection
    const baseDesktopWidth = 1366.0; // Common laptop resolution

    // Detect browser zoom level using viewport reduction + DPR
    double detectedZoom = 1.0;

    // Advanced zoom detection algorithm
    if (devicePixelRatio > 1.0) {
      // Method 1: Viewport-based detection
      double viewportZoom = 1.0;
      if (screenWidth < baseDesktopWidth) {
        viewportZoom = baseDesktopWidth / screenWidth;
      }

      // Method 2: Device pixel ratio correlation
      double dprZoom = devicePixelRatio;

      // Combine both methods for accurate detection
      detectedZoom = math.max(viewportZoom, dprZoom);
    } else {
      // Fallback for DPR = 1.0
      if (screenWidth < baseDesktopWidth) {
        detectedZoom = baseDesktopWidth / screenWidth;
      }
    }

    // Clamp to realistic browser zoom range
    detectedZoom = detectedZoom.clamp(0.5, 5.0);

    // APPLY CUSTOM SCALING TABLE WITH EXTREME ZOOM SUPPORT
    double customScaleFactor = _getCustomScaleFromZoom(detectedZoom);

    // FULL FLEX SHRINK MODE for extreme zoom levels
    if (detectedZoom >= 3.0) {
      // 300%+ zoom: Ultra-compact mode
      customScaleFactor *= 0.5; // Reduce by 50%
    } else if (detectedZoom >= 2.5) {
      // 250%+ zoom: Super-compact mode
      customScaleFactor *= 0.6; // Reduce by 40%
    } else if (detectedZoom >= 2.0) {
      // 200%+ zoom: Compact mode
      customScaleFactor *= 0.75; // Reduce by 25%
    }

    return {
      'detectedZoom': detectedZoom,
      'customScale': customScaleFactor.clamp(
        0.3,
        2.0,
      ), // Always stay within bounds
    };
  }

  // YOUR CUSTOM SCALING TABLE IMPLEMENTATION
  double _getCustomScaleFromZoom(double browserZoom) {
    // Convert browser zoom percentage to your custom UI scale
    // Browser 100% → UI 80%
    // Browser 120% → UI 90%
    // Browser 125% → UI 100% (normal)
    // Browser 150% → UI 125%
    // Browser 200% → UI 150%

    final scalingTable = <double, double>{
      1.00: 0.80, // Browser 100% → UI 80%
      1.20: 0.90, // Browser 120% → UI 90%
      1.25: 1.00, // Browser 125% → UI 100% (normal)
      1.50: 1.25, // Browser 150% → UI 125%
      2.00: 1.50, // Browser 200% → UI 150%
    };

    // Find exact match first
    if (scalingTable.containsKey(browserZoom)) {
      return scalingTable[browserZoom]!;
    }

    // Interpolate between closest values for smooth scaling
    final zoomLevels = scalingTable.keys.toList()..sort();

    // Handle edge cases
    if (browserZoom <= zoomLevels.first) {
      return scalingTable[zoomLevels.first]!;
    }
    if (browserZoom >= zoomLevels.last) {
      return scalingTable[zoomLevels.last]!;
    }

    // Find interpolation range
    double lowerZoom = zoomLevels.first;
    double upperZoom = zoomLevels.last;

    for (int i = 0; i < zoomLevels.length - 1; i++) {
      if (browserZoom >= zoomLevels[i] && browserZoom <= zoomLevels[i + 1]) {
        lowerZoom = zoomLevels[i];
        upperZoom = zoomLevels[i + 1];
        break;
      }
    }

    // Linear interpolation
    final lowerScale = scalingTable[lowerZoom]!;
    final upperScale = scalingTable[upperZoom]!;
    final ratio = (browserZoom - lowerZoom) / (upperZoom - lowerZoom);

    return lowerScale + (upperScale - lowerScale) * ratio;
  }

  ResponsiveBreakpoint _resolveBreakpoint(double width) {
    // Enhanced breakpoints for zoom support
    // 1366px @ 150% zoom = ~911px effective viewport
    if (width < 480) return ResponsiveBreakpoint.mobile; // Very small
    if (width < 768) return ResponsiveBreakpoint.mobile; // Mobile
    if (width < 1024) return ResponsiveBreakpoint.tablet; // Tablet/Small laptop
    if (width < 1440)
      return ResponsiveBreakpoint.desktop; // Desktop/1366px+zoom
    return ResponsiveBreakpoint.desktop; // Large desktop
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
