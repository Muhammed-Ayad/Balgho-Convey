import 'package:flutter/material.dart';
import 'package:great_quran/theme/colors.dart';
import '../ui/qibla/qibla_screen.dart';
import '../ui/nawawi/nawawi_screen.dart';
import '../ui/quran/quran_screen.dart';
import '../ui/radios/radio_categories_screen.dart';
import '../ui/azan/azan_screen.dart';
import '../ui/azkar/alzkar_screen.dart';
import '../ui/contant_us/contant_us_view.dart';
import '../ui/main_view.dart';

class Routes {
  static const String mainRoute = "/main";
  static const String azanRoute = "/azan";
  static const String azkarRoute = "/azkarView";
  static const String contantUsRoute = "/contantUs";
  static const String kibleRoute = "/kible";
  static const String nawawiRoute = "/nawawi";
  static const String quranRoute = "/quran";
  static const String radiosRoute = "/radios";
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case Routes.mainRoute:
        return MaterialPageRoute(builder: (_) => const MainView());
      case Routes.azanRoute:
        return MaterialPageRoute(builder: (_) => const AzanScreen());
      case Routes.contantUsRoute:
        return MaterialPageRoute(builder: (_) => const ContantUsView());
      case Routes.azkarRoute:
        return MaterialPageRoute(builder: (_) => const AzkarScreen());
      case Routes.kibleRoute:
        return MaterialPageRoute(builder: (_) => const QiblaScreen());
      case Routes.nawawiRoute:
        return MaterialPageRoute(builder: (_) => const NawawiScreen());
      case Routes.quranRoute:
        return MaterialPageRoute(builder: (_) => const QuranScreen());
      case Routes.radiosRoute:
        return MaterialPageRoute(builder: (_) => const RadioCategoriesScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        backgroundColor: AppColors.white,
      );
    });
  }
}
