import 'package:flutter/material.dart';
import 'package:great_quran/core/theme/colors.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/core/theme/font_manager.dart';
import 'package:great_quran/core/theme/text_styles.dart';

mixin AppTheme {
  static ThemeData themeFactory() {
    return ThemeData(
      fontFamily: FontFamilyNames.messiriFont,
      colorScheme: ThemeData().colorScheme.copyWith(
            primary: const Color(0xFF64BFBE),
            secondary: const Color(0xFFCEC3C3),
            surface: AppColors.white,
            shadow: AppColors.greyShade200,
            onSurfaceVariant: AppColors.greyShade500,
            error: AppColors.red,
          ),
      iconTheme: const IconThemeData(),
      tabBarTheme: const TabBarThemeData(),
      appBarTheme: const AppBarTheme(),
      inputDecorationTheme: const InputDecorationTheme(),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: AppTextStyles.getRegularStyle(
              color: AppColors.white, fontSize: FontSizeManager.s12),
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(D.sizeMedium),
          ),
        ),
      ),
      textTheme: TextTheme(
        displayMedium: AppTextStyles.getMediumStyle(
            color: AppColors.darkGrey, fontSize: FontSizeManager.s22),
        displayLarge: AppTextStyles.getSemiBoldStyle(
            color: AppColors.darkGrey, fontSize: FontSizeManager.s22),
        headlineSmall: AppTextStyles.getSemiBoldStyle(
            color: AppColors.darkGrey, fontSize: FontSizeManager.s18),
        headlineMedium: AppTextStyles.getMediumStyle(
            color: AppColors.darkGrey, fontSize: FontSizeManager.s20),
        headlineLarge: AppTextStyles.getSemiBoldStyle(
            color: AppColors.darkGrey, fontSize: FontSizeManager.s22),
        titleSmall: AppTextStyles.getRegularStyle(
            color: AppColors.darkGrey, fontSize: FontSizeManager.s18),
        titleMedium: AppTextStyles.getMediumStyle(
            color: AppColors.darkGrey, fontSize: FontSizeManager.s20),
        titleLarge: AppTextStyles.getSemiBoldStyle(
            color: AppColors.primary, fontSize: FontSizeManager.s22),
        bodySmall: AppTextStyles.getRegularStyle(color: AppColors.grey),
        bodyMedium: AppTextStyles.getMediumStyle(color: AppColors.grey),
        bodyLarge: AppTextStyles.getSemiBoldStyle(
            color: AppColors.grey, fontSize: FontSizeManager.s14),
      ),
      bottomSheetTheme: const BottomSheetThemeData(),
    );
  }
}
