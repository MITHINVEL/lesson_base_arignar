import 'package:flutter/material.dart';
import 'package:lesson_base_arignar/theme/app_colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  static TextStyle headlineLarge(BuildContext context) =>
      Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: AppColors.darkText,
            fontWeight: FontWeight.w700,
          ) ??
      const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.darkText,
      );

  static TextStyle headlineMedium(BuildContext context) =>
      Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.darkText,
            fontWeight: FontWeight.w600,
          ) ??
      const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.darkText,
      );

  static TextStyle titleMedium(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.darkText,
            fontWeight: FontWeight.w600,
          ) ??
      const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.darkText,
      );

  static TextStyle bodyLarge(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.darkText,
            fontWeight: FontWeight.w500,
          ) ??
      const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.darkText,
      );

  static TextStyle bodyMedium(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.subtleText,
          ) ??
      const TextStyle(
        fontSize: 14,
        color: AppColors.subtleText,
      );
}




