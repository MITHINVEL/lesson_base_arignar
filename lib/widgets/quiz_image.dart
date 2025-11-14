import 'package:flutter/material.dart';

class QuizImage extends StatelessWidget {
  const QuizImage({
    super.key,
    required this.imageUrl,
    this.aspectRatio = 16 / 9,
  });

  final String? imageUrl;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;

    // Responsive calculations for zoom support
    final isVeryCompact = screenWidth < 400;
    final isCompact = screenWidth < 600;

    // Dynamic sizing - reduced width for luxury appearance
    final containerWidth =
        screenWidth * (isVeryCompact ? 0.85 : (isCompact ? 0.8 : 0.75));
    final maxContainerWidth = isCompact ? 320.0 : 420.0;
    final finalWidth = containerWidth.clamp(280.0, maxContainerWidth);

    // Border radius based on viewport
    final borderRadius = (screenWidth * 0.05).clamp(22.0, 28.0);
    final shadowBlurRadius = (screenWidth * 0.02).clamp(8.0, 14.0);

    return Center(
      child: Container(
        width: finalWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: shadowBlurRadius,
              offset: const Offset(0, 4),
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: imageUrl != null && imageUrl!.isNotEmpty
                ? Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: const Color(0xFFF5F5F5),
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                            strokeWidth: 2,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFFFF8F00),
                            ),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFF5F5F5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported_rounded,
                              size: finalWidth * 0.15,
                              color: const Color(0xFFBDBDBD),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Unable to load image',
                              style: TextStyle(
                                fontSize: finalWidth * 0.035,
                                color: const Color(0xFF757575),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Container(
                    color: const Color(0xFFF5F5F5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_rounded,
                          size: finalWidth * 0.15,
                          color: const Color(0xFFBDBDBD),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No image available',
                          style: TextStyle(
                            fontSize: finalWidth * 0.035,
                            color: const Color(0xFF757575),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
