import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Text widget that scales font size based on the available viewport width.
class ScalableText extends StatelessWidget {
  const ScalableText(
    this.text, {
    super.key,
    this.style,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.autoScale = true,
    this.minFontSize,
    this.maxFontSize,
  });

  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final bool autoScale;
  final double? minFontSize;
  final double? maxFontSize;

  @override
  Widget build(BuildContext context) {
    final baseStyle =
        style ?? Theme.of(context).textTheme.bodyMedium ?? const TextStyle();

    if (!autoScale) {
      return Text(
        text,
        style: baseStyle,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
      );
    }

    final media = MediaQuery.maybeOf(context);
    final width = media?.size.width ?? 1024.0;
    // Enhanced width range to handle zoom scenarios
    const minWidth = 320.0;
    const maxWidth = 1600.0; // Support larger viewports

    // Improved font size calculation for zoom scenarios
    final baseFont = baseStyle.fontSize ?? 16;
    final minSize = minFontSize ?? (baseFont * 0.80).clamp(12.0, baseFont);
    final maxSize = maxFontSize ?? (baseFont * 1.40).clamp(baseFont, 32.0);

    final clampFactor = ((width - minWidth) / (maxWidth - minWidth)).clamp(
      0.0,
      1.0,
    );
    final fontSize = lerpDouble(minSize, maxSize, clampFactor)!;

    final scaledStyle = baseStyle.copyWith(fontSize: fontSize);

    return Text(
      text,
      style: scaledStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textScaler: media?.textScaler ?? TextScaler.noScaling,
    );
  }
}
