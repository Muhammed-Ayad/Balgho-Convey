import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/generated/locale_keys.g.dart';
import 'package:great_quran/theme/themes.dart';
import 'package:great_quran/resources/routes_manager.dart';

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
        title: LocaleKeys.app_name.tr(),
        debugShowCheckedModeBanner: false,
        theme: AppTheme.themeFactory(),
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: Routes.mainRoute,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
      ),
    );
  }
}
