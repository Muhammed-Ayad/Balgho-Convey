import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/generated/locale_keys.g.dart';
import 'package:great_quran/resources/routes_manager.dart';
import 'package:great_quran/services/local_notification_service.dart';
import 'package:great_quran/theme/themes.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp._internal();
  static const MyApp instance = MyApp._internal();
  factory MyApp() => instance;

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();

    _initLocalNotification();
  }

  Future<void> _initLocalNotification() async {
    final notificationService = ref.read(LocalNotificationService.provider);
    await notificationService.init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => LocaleKeys.app_name.tr(),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeFactory(),
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: Routes.mainRoute,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
