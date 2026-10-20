import 'package:flutter/material.dart';
import 'package:great_quran/core/routes/routes_manager.dart';
import 'package:great_quran/core/services/local_notification_service.dart';
import 'package:great_quran/core/theme/themes.dart';
import 'package:great_quran/l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeFactory(),
      routerConfig: appRouter,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ar'),
    );
  }
}
