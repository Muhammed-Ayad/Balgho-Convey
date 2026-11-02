import 'package:flutter/material.dart';
import 'package:great_quran/core/routes/routes_manager.dart';
import 'package:great_quran/core/services/flip_to_mute_service.dart';
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

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  DateTime? _lastSyncTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initLocalNotification();
    ref.read(FlipToMuteService.provider).initialize();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _reSyncNotifications();
    }
  }

  Future<void> _reSyncNotifications() async {
    try {
      final now = DateTime.now();
      // Throttle: Don't resync on resume if synced recently (within 30 mins)
      // UNLESS the calendar day changed.
      if (_lastSyncTime != null) {
        final sameDay = _lastSyncTime!.year == now.year &&
            _lastSyncTime!.month == now.month &&
            _lastSyncTime!.day == now.day;
        final difference = now.difference(_lastSyncTime!);
        if (sameDay && difference < const Duration(minutes: 30)) {
          debugPrint(
              "MyApp: Resumed -> Skipping resync, synced recently: ${difference.inMinutes}m ago");
          return;
        }
      }

      final notificationService = ref.read(LocalNotificationService.provider);
      if (!notificationService.isInitSuccess) {
        await notificationService.init();
      }

      final settingsRepo = ref.read(NotificationSettingsRepository.provider);
      final scheduler = ref.read(NotificationSchedulerService.provider);
      final settings = await settingsRepo.getSettings();
      if (settings.allNotificationsEnabled) {
        _lastSyncTime = now;
        debugPrint(
            "MyApp: Resuming app -> resyncing notification schedules...");
        await scheduler.syncSchedules(settings);
      }
    } catch (e, s) {
      debugPrint("MyApp: Error in _reSyncNotifications: $e\n$s");
    }
  }

  Future<void> _initLocalNotification() async {
    final notificationService = ref.read(LocalNotificationService.provider);
    if (!notificationService.isInitSuccess) {
      await notificationService.init();
    }
    try {
      debugPrint("MyApp: Requesting notification permissions on app launch...");
      await notificationService.requestPermissions();

      final settingsRepo = ref.read(NotificationSettingsRepository.provider);
      final scheduler = ref.read(NotificationSchedulerService.provider);
      final settings = await settingsRepo.getSettings();
      _lastSyncTime = DateTime.now();
      debugPrint(
          "MyApp: Initial syncSchedules on startup (allEnabled: ${settings.allNotificationsEnabled})...");
      await scheduler.syncSchedules(settings);
    } catch (e, s) {
      debugPrint("MyApp: Error in _initLocalNotification: $e\n$s");
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
