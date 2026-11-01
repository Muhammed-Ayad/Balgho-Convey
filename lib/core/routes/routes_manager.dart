import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:great_quran/core/theme/colors.dart';
import 'package:great_quran/feature/azan/view/screens/azan_screen.dart';
import 'package:great_quran/feature/azkar/view/screens/azkar_category_screen.dart';
import 'package:great_quran/feature/azkar/view/screens/azkar_screen.dart';
import 'package:great_quran/feature/contact_us/view/screens/contact_us_screen.dart';
import 'package:great_quran/feature/favorites/view/screens/favorites_screen.dart';
import 'package:great_quran/feature/habits/view/screens/habits_screen.dart';
import 'package:great_quran/feature/home/view/screens/home_screen.dart';
import 'package:great_quran/feature/home/view/screens/widgets_guide_screen.dart';
import 'package:great_quran/feature/settings/view/screens/azan_settings_screen.dart';
import 'package:great_quran/feature/nawawi/view/screens/nawawi_screen.dart';
import 'package:great_quran/feature/qibla/view/screens/qibla_screen.dart';
import 'package:great_quran/feature/notifications/view/screens/notifications_settings_screen.dart';
import 'package:great_quran/feature/prophet/logic/models/prophet_topic.dart';
import 'package:great_quran/feature/prophet/view/screens/prophet_detail_screen.dart';
import 'package:great_quran/feature/prophet/view/screens/prophet_screen.dart';
import 'package:great_quran/feature/quran/view/screens/quran_index_screen.dart';
import 'package:great_quran/feature/quran/view/screens/surah_detail_screen.dart';
import 'package:great_quran/feature/radios/logic/models/radio.dart';
import 'package:great_quran/feature/radios/view/screens/audio_page.dart';
import 'package:great_quran/feature/radios/view/screens/radio_categories_screen.dart';
import 'package:great_quran/feature/radios/view/screens/radios_screen.dart';
import 'package:great_quran/feature/settings/view/screens/settings_screen.dart';
import 'package:great_quran/feature/tasbih/view/screens/tasbih_screen.dart';

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
  static const String settingsRoute = "/settings";
  static const String notificationsSettingsRoute = "/notificationsSettings";
  static const String azanSettingsRoute = "/azanSettings";
  static const String widgetsGuideRoute = "/widgetsGuide";
  static const String tasbihRoute = "/tasbih";
  static const String favoritesRoute = "/favorites";
  static const String habitsRoute = "/habits";
  static const String quranRoute = "/quran";
  static const String surahRoute = "/surah";
  static const String prophetRoute = "/prophet";
  static const String prophetDetailRoute = "/prophetDetail";
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
        if (state.extra is Map<String, dynamic>) {
          final map = state.extra as Map<String, dynamic>;
          final list = map['radioList'] as List<RadioDetalis>;
          final index = map['initialIndex'] as int? ?? 0;
          return AudioPage(radioList: list, initialIndex: index);
        } else if (state.extra is RadioDetalis) {
          final radioDetalis = state.extra as RadioDetalis;
          return AudioPage.single(radioDetalis: radioDetalis);
        }
        return AudioPage(radioList: const []);
      },
    ),
    GoRoute(
      path: Routes.settingsRoute,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: Routes.notificationsSettingsRoute,
      builder: (context, state) => const NotificationsSettingsScreen(),
    ),
    GoRoute(
      path: Routes.azanSettingsRoute,
      builder: (context, state) => const AzanSettingsScreen(),
    ),
    GoRoute(
      path: Routes.widgetsGuideRoute,
      builder: (context, state) => const WidgetsGuideScreen(),
    ),
    GoRoute(
      path: Routes.favoritesRoute,
      builder: (context, state) => const FavoritesScreen(),
    ),
    GoRoute(
      path: Routes.habitsRoute,
      builder: (context, state) => const HabitsScreen(),
    ),
    GoRoute(
      path: Routes.tasbihRoute,
      builder: (context, state) => const TasbihScreen(),
    ),
    GoRoute(
      path: Routes.quranRoute,
      builder: (context, state) => const QuranIndexScreen(),
    ),
    GoRoute(
      path: Routes.surahRoute,
      builder: (context, state) {
        if (state.extra is int) {
          return SurahDetailScreen(surahNumber: state.extra as int);
        } else if (state.extra is Map<String, dynamic>) {
          final map = state.extra as Map<String, dynamic>;
          return SurahDetailScreen(
            surahNumber: map['surahNumber'] as int,
            initialAyahNumber: map['ayahNumber'] as int?,
          );
        }
        return const SurahDetailScreen(surahNumber: 1);
      },
    ),
    GoRoute(
      path: Routes.prophetRoute,
      builder: (context, state) => const ProphetScreen(),
    ),
    GoRoute(
      path: Routes.prophetDetailRoute,
      builder: (context, state) {
        final topic = state.extra as ProphetTopic;
        return ProphetDetailScreen(topic: topic);
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    backgroundColor: AppColors.primary,
  ),
);
