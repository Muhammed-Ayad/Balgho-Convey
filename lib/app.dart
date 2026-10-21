import 'package:flutter/material.dart';
import 'package:great_quran/core/routes/routes_manager.dart';
import 'package:great_quran/core/services/local_notification_service.dart';
import 'package:great_quran/core/services/notification_scheduler_service.dart';
import 'package:great_quran/core/theme/theme_provider.dart';
import 'package:great_quran/core/theme/themes.dart';
import 'package:great_quran/feature/notifications/logic/repo/notification_settings_repository.dart';
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
    final success = await notificationService.init();
    if (success) {
      try {
        final settingsRepo = ref.read(NotificationSettingsRepository.provider);
        final scheduler = ref.read(NotificationSchedulerService.provider);
        final settings = await settingsRepo.getSettings();
        await scheduler.syncSchedules(settings);
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentThemeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: currentThemeMode,
      routerConfig: appRouter,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ar'),
    );
  }
}
