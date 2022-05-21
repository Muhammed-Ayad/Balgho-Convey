import 'package:flutter/material.dart';
import '../kibla/kiblat_view.dart';
import '../nawawi/nawawi_view.dart';
import '../quran/quran_view.dart';
import '../radios/radios_view.dart';
import 'strings_manager.dart';
import '../azan/azan_view.dart';
import '../azkar/alzkar_view.dart';
import '../contant_us/contant_us_view.dart';
import '../main/main_view.dart';

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
        return MaterialPageRoute(builder: (_) => const AzanView());
      case Routes.contantUsRoute:
        return MaterialPageRoute(builder: (_) => const ContantUsView());
      case Routes.azkarRoute:
        return MaterialPageRoute(builder: (_) => const AzkarView());
      case Routes.kibleRoute:
        return MaterialPageRoute(builder: (_) => const KibleView());
      case Routes.nawawiRoute:
        return MaterialPageRoute(builder: (_) => const NawawiView());
      case Routes.quranRoute:
        return MaterialPageRoute(builder: (_) => const QuranView());
      case Routes.radiosRoute:
        return MaterialPageRoute(builder: (_) => const RadiosView());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.noRoutes),
        ),
        body: const Center(
          child: Text(AppStrings.noRoutes),
        ),
      );
    });
  }
}
