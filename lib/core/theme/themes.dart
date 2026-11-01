import 'package:flutter/material.dart';
import 'package:great_quran/core/theme/colors.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/core/theme/font_manager.dart';
import 'package:great_quran/core/theme/text_styles.dart';

mixin AppTheme {
  static ThemeData themeFactory() => lightTheme();

  static ThemeData lightTheme() {
    const primary = Color(0xFF008080);
    const secondary = Color(0xFF64BFBE);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: FontFamilyNames.messiriFont,
      scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: Colors.white,
        onSurface: Color(0xFF1E293B),
        shadow: Color(0xFFE2E8F0),
        error: Color(0xFFE61F34),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF1E293B),
        elevation: 0.5,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: AppTextStyles.getRegularStyle(
            color: Colors.white,
            fontSize: FontSizeManager.s14,
          ),
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(D.sizeMedium),
          ),
        ),
      ),
      textTheme: TextTheme(
        displayMedium: AppTextStyles.getMediumStyle(
          color: AppColors.darkGrey,
          fontSize: FontSizeManager.s22,
        ),
        displayLarge: AppTextStyles.getSemiBoldStyle(
          color: AppColors.darkGrey,
          fontSize: FontSizeManager.s22,
        ),
        headlineSmall: AppTextStyles.getSemiBoldStyle(
          color: AppColors.darkGrey,
          fontSize: FontSizeManager.s18,
        ),
        headlineMedium: AppTextStyles.getMediumStyle(
          color: AppColors.darkGrey,
          fontSize: FontSizeManager.s20,
        ),
        headlineLarge: AppTextStyles.getSemiBoldStyle(
          color: AppColors.darkGrey,
          fontSize: FontSizeManager.s22,
        ),
        titleSmall: AppTextStyles.getRegularStyle(
          color: AppColors.darkGrey,
          fontSize: FontSizeManager.s16,
        ),
        titleMedium: AppTextStyles.getMediumStyle(
          color: AppColors.darkGrey,
          fontSize: FontSizeManager.s18,
        ),
        titleLarge: AppTextStyles.getSemiBoldStyle(
          color: primary,
          fontSize: FontSizeManager.s22,
        ),
        bodySmall: AppTextStyles.getRegularStyle(color: AppColors.grey),
        bodyMedium: AppTextStyles.getMediumStyle(color: AppColors.grey),
        bodyLarge: AppTextStyles.getSemiBoldStyle(
          color: AppColors.grey,
          fontSize: FontSizeManager.s14,
        ),
      ),
    );
  }

  static ThemeData darkTheme() {
    const primary = Color(0xFF2DD4BF);
    const secondary = Color(0xFF14B8A6);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: FontFamilyNames.messiriFont,
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: Color(0xFF1E293B),
        onSurface: Color(0xFFF1F5F9),
        shadow: Color(0xFF0B1120),
        error: Color(0xFFF87171),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E293B),
        foregroundColor: Color(0xFFF1F5F9),
        elevation: 0.5,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: AppTextStyles.getRegularStyle(
            color: const Color(0xFF0F172A),
            fontSize: FontSizeManager.s14,
          ),
          backgroundColor: primary,
          foregroundColor: const Color(0xFF0F172A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(D.sizeMedium),
          ),
        ),
      ),
      textTheme: TextTheme(
        displayMedium: AppTextStyles.getMediumStyle(
          color: const Color(0xFFF1F5F9),
          fontSize: FontSizeManager.s22,
        ),
        displayLarge: AppTextStyles.getSemiBoldStyle(
          color: const Color(0xFFF1F5F9),
          fontSize: FontSizeManager.s22,
        ),
        headlineSmall: AppTextStyles.getSemiBoldStyle(
          color: const Color(0xFFF1F5F9),
          fontSize: FontSizeManager.s18,
        ),
        headlineMedium: AppTextStyles.getMediumStyle(
          color: const Color(0xFFF1F5F9),
          fontSize: FontSizeManager.s20,
        ),
        headlineLarge: AppTextStyles.getSemiBoldStyle(
          color: const Color(0xFFF1F5F9),
          fontSize: FontSizeManager.s22,
        ),
        titleSmall: AppTextStyles.getRegularStyle(
          color: const Color(0xFFCBD5E1),
          fontSize: FontSizeManager.s16,
        ),
        titleMedium: AppTextStyles.getMediumStyle(
          color: const Color(0xFFF1F5F9),
          fontSize: FontSizeManager.s18,
        ),
        titleLarge: AppTextStyles.getSemiBoldStyle(
          color: primary,
          fontSize: FontSizeManager.s22,
        ),
        bodySmall: AppTextStyles.getRegularStyle(
          color: const Color(0xFF94A3B8),
        ),
        bodyMedium: AppTextStyles.getMediumStyle(
          color: const Color(0xFFCBD5E1),
        ),
        bodyLarge: AppTextStyles.getSemiBoldStyle(
          color: const Color(0xFFCBD5E1),
          fontSize: FontSizeManager.s14,
        ),
      ),
    );
  }
}
