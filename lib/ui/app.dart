import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/theme/themes.dart';
import 'package:great_quran/resources/routes_manager.dart';
import 'package:great_quran/resources/strings_manager.dart';

class MyApp extends StatefulWidget {
  const MyApp._internal();
  static const MyApp instance = MyApp._internal();
  factory MyApp() => instance;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: AppStrings.titleApp,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.themeFactory(),
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: Routes.mainRoute,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale(AppStrings.languageCode, AppStrings.countryCode),
        ],
      ),
    );
  }
}
