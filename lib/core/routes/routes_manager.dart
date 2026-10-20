import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:great_quran/core/theme/colors.dart';
import 'package:great_quran/feature/azan/view/screens/azan_screen.dart';
import 'package:great_quran/feature/azkar/view/screens/azkar_category_screen.dart';
import 'package:great_quran/feature/azkar/view/screens/azkar_screen.dart';
import 'package:great_quran/feature/contact_us/view/screens/contact_us_screen.dart';
import 'package:great_quran/feature/home/view/screens/home_screen.dart';
import 'package:great_quran/feature/nawawi/view/screens/nawawi_screen.dart';
import 'package:great_quran/feature/qibla/view/screens/qibla_screen.dart';
import 'package:great_quran/feature/radios/logic/models/radio.dart';
import 'package:great_quran/feature/radios/view/screens/audio_page.dart';
import 'package:great_quran/feature/radios/view/screens/radio_categories_screen.dart';
import 'package:great_quran/feature/radios/view/screens/radios_screen.dart';

class Routes {
  static const String mainRoute = "/";
  static const String azanRoute = "/azan";
  static const String azkarRoute = "/azkar";
  static const String azkarCategoryRoute = "/azkarCategory";
  static const String contactUsRoute = "/contactUs";
  static const String qiblaRoute = "/qibla";
  static const String nawawiRoute = "/nawawi";
  static const String radiosRoute = "/radios";
  static const String radiosScreenRoute = "/radiosScreen";
  static const String audioPageRoute = "/audioPage";
}

final appRouter = GoRouter(
  initialLocation: Routes.mainRoute,
  routes: [
    GoRoute(
      path: Routes.mainRoute,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: Routes.azanRoute,
      builder: (context, state) => const AzanScreen(),
    ),
    GoRoute(
      path: Routes.contactUsRoute,
      builder: (context, state) => const ContactUsScreen(),
    ),
    GoRoute(
      path: Routes.azkarRoute,
      builder: (context, state) => const AzkarScreen(),
    ),
    GoRoute(
      path: Routes.azkarCategoryRoute,
      builder: (context, state) {
        final azkar = state.extra as String;
        return AzkarCategoryScreen(azkar: azkar);
      },
    ),
    GoRoute(
      path: Routes.qiblaRoute,
      builder: (context, state) => const QiblaScreen(),
    ),
    GoRoute(
      path: Routes.nawawiRoute,
      builder: (context, state) => const NawawiScreen(),
    ),
    GoRoute(
      path: Routes.radiosRoute,
      builder: (context, state) => const RadioCategoriesScreen(),
    ),
    GoRoute(
      path: Routes.radiosScreenRoute,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return RadiosScreen(
          radioDetalis: extra['radioDetalis'] as List<RadioDetalis>,
          title: extra['title'] as String,
        );
      },
    ),
    GoRoute(
      path: Routes.audioPageRoute,
      builder: (context, state) {
        final radioDetalis = state.extra as RadioDetalis;
        return AudioPage(radioDetalis: radioDetalis);
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    backgroundColor: AppColors.primary,
  ),
);
