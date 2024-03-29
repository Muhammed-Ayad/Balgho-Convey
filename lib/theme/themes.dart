import 'package:flutter/material.dart';
import 'package:great_quran/theme/colors.dart';
import 'package:great_quran/theme/dimensions.dart';
import 'package:great_quran/theme/text_styles.dart';
import 'package:great_quran/theme/font_manager.dart';

mixin AppTheme {
  static ThemeData themeFactory() {
    // ThemeData
    return ThemeData(
      // <------------------------------------------------ Main Theme Font
      fontFamily: FontFamilyNames.messiriFont,

      // <------------------------------------------ Color Scheme
      colorScheme: ThemeData().colorScheme.copyWith(
            primary: const Color(0xFF64BFBE),
            secondary: const Color(0xFFCEC3C3),
            surface: AppColors.white,
            background: AppColors.grey,
            shadow: AppColors.greyShade200,
            onBackground: AppColors.greyShade500,
            error: AppColors.red,
          ),

      // <------------------------------------------------ Icon Theme
      iconTheme: const IconThemeData(),

      // <------------------------------------------------ Tab Bar Theme
      tabBarTheme: const TabBarTheme(),

      // <------------------------------------------------ App Bar Theme Theme
      appBarTheme: const AppBarTheme(),

      // <------------------------------------------------ Input Decoration Theme
      inputDecorationTheme: const InputDecorationTheme(),

      // <------------------------------------------------ elevation Button theme
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

      // <------------------------------------------------ Text Theme

      textTheme: TextTheme(
        displayMedium: AppTextStyles.getMediumStyle(
            color: AppColors.darkGrey, fontSize: FontSizeManager.s22),
        displayLarge: AppTextStyles.getSemiBoldStyle(
            color: AppColors.darkGrey, fontSize: FontSizeManager.s22),
        headlineSmall: AppTextStyles.getSemiBoldStyle(
            color: AppColors.darkGrey, fontSize: FontSizeManager.s18),
        //* appBarTitle
        headlineMedium: AppTextStyles.getMediumStyle(
            color: AppColors.darkGrey, fontSize: FontSizeManager.s20),
        //* bag title
        headlineLarge: AppTextStyles.getSemiBoldStyle(
            color: AppColors.darkGrey, fontSize: FontSizeManager.s22),
        //* smoll text
        titleSmall: AppTextStyles.getRegularStyle(
            color: AppColors.darkGrey, fontSize: FontSizeManager.s18),
        titleMedium: AppTextStyles.getMediumStyle(
            color: AppColors.darkGrey, fontSize: FontSizeManager.s20),
        titleLarge: AppTextStyles.getSemiBoldStyle(
            color: AppColors.primary, fontSize: FontSizeManager.s22),
        //* bag text
        bodySmall: AppTextStyles.getRegularStyle(color: AppColors.grey),
        bodyMedium: AppTextStyles.getMediumStyle(color: AppColors.grey),
        bodyLarge: AppTextStyles.getSemiBoldStyle(
            color: AppColors.grey, fontSize: FontSizeManager.s14),
      ),

      // <--------------------------------------- Bottomsheet Theme
      bottomSheetTheme: const BottomSheetThemeData(),
    );
  }
}
