import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/routes/routes_manager.dart';
import 'package:great_quran/core/services/local_notification_service.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/core/widgets/custom_app_bar.dart';
import 'package:great_quran/feature/azkar/logic/providers/notifications_subscription_notifier.dart';
import 'package:great_quran/feature/daily_zekr/logic/providers/daily_zekr_provider.dart';
import 'package:great_quran/feature/daily_zekr/view/widgets/daily_zekr_card.dart';
import 'package:great_quran/feature/home/view/widgets/feature_grid_card.dart';
import 'package:great_quran/feature/home/view/widgets/morning_evening_azkar_card.dart';
import 'package:great_quran/feature/home/view/widgets/next_prayer_card.dart';
import 'package:great_quran/feature/home/view/widgets/section_header.dart';
import 'package:great_quran/feature/notifications/logic/providers/notification_settings_provider.dart';
import 'package:great_quran/feature/notifications/view/widgets/exact_alarm_rationale_dialog.dart';
import 'package:great_quran/feature/radios/view/widgets/radio_mini_player_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  bool _wasExactAlarmGranted = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ref
        .read(NotificationsSubscriptionNotifier.provider.notifier)
        .navigateOnNotificationLaunch(
          (category) =>
              context.push(Routes.azkarCategoryRoute, extra: category),
          onRoute: (route) => context.push(route),
        );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFirstRunPermissions();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(dailyZekrProvider);
      _checkExactAlarmOnResume();
    }
  }

  Future<void> _checkFirstRunPermissions() async {
    try {
      final notifService = ref.read(LocalNotificationService.provider);
      final notifNotifier =
          ref.read(NotificationSettingsNotifier.provider.notifier);

      debugPrint(
          "HomeScreen: Requesting notification permission (POST_NOTIFICATIONS)...");
      final notificationsGranted = await notifService.requestPermissions();
      debugPrint(
          "HomeScreen: Notification permission result = $notificationsGranted");

      final canExact = await notifService.canScheduleExactNotifications();
      _wasExactAlarmGranted = canExact;
      debugPrint("HomeScreen: canScheduleExactNotifications = $canExact");

      final hasPrompted = await notifNotifier.isExactAlarmPromptShown();
      debugPrint("HomeScreen: exact_alarm_prompt_shown = $hasPrompted");

      if (!canExact && !hasPrompted) {
        await notifNotifier.setExactAlarmPromptShown(true);

        if (!mounted) return;
        debugPrint("HomeScreen: Presenting ExactAlarmRationaleDialog...");
        final shouldOpen = await ExactAlarmRationaleDialog.show(context);
        debugPrint("HomeScreen: ExactAlarmRationaleDialog result: $shouldOpen");

        if (shouldOpen == true) {
          if (!mounted) return;
          await notifNotifier.openExactAlarmSettings();
        } else {
          debugPrint(
              "HomeScreen: User dismissed or postponed exact alarm permission. Scheduling with fallback.");
          await notifNotifier.requestPermissionsAndSync();
        }
      }
    } catch (e, stack) {
      debugPrint("HomeScreen: Error in _checkFirstRunPermissions: $e\n$stack");
    }
  }

  Future<void> _checkExactAlarmOnResume() async {
    try {
      final notifService = ref.read(LocalNotificationService.provider);
      final canExact = await notifService.canScheduleExactNotifications();
      debugPrint(
          "HomeScreen: App resumed. canScheduleExactNotifications = $canExact (was: $_wasExactAlarmGranted)");

      if (!_wasExactAlarmGranted && canExact) {
        _wasExactAlarmGranted = true;
        debugPrint(
            "HomeScreen: Exact alarm permission was just granted! Re-syncing notifications...");
        final notifNotifier =
            ref.read(NotificationSettingsNotifier.provider.notifier);
        await notifNotifier.requestPermissionsAndSync();

        if (mounted) {
          Fluttertoast.showToast(
            msg:
                "تم تفعيل إذن المنبهات الدقيقة بنجاح! تم ضبط مواقيت الإشعارات ⏰",
            backgroundColor: const Color(0xFF00695C),
            textColor: Colors.white,
            toastLength: Toast.LENGTH_LONG,
          );
        }
      } else {
        _wasExactAlarmGranted = canExact;
      }
    } catch (e, stack) {
      debugPrint("HomeScreen: Error in _checkExactAlarmOnResume: $e\n$stack");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: context.l10n.titleAppBar,
        actions: [
          IconButton(
            icon: const Icon(Icons.star_rounded, color: Colors.amber),
            tooltip: "المفضلة",
            onPressed: () {
              context.push(Routes.favoritesRoute);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: "الإعدادات",
            onPressed: () {
              context.push(Routes.settingsRoute);
            },
          ),
        ],
      ),
      bottomNavigationBar: const RadioMiniPlayerWidget(),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: D.sizeSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NextPrayerCard(),
              DailyZekrCard(),
              SizedBox(height: D.sizeSmall),
              HomeSectionHeaderWidget(
                title: "أذكار اليوم والليلة",
                icon: Icons.wb_twilight_rounded,
              ),
              MorningEveningAzkarSectionWidget(),
              SizedBox(height: D.sizeMedium),
              HomeSectionHeaderWidget(
                title: "الخدمات الإسلامية",
                icon: Icons.grid_view_rounded,
              ),
              MainFeaturesGridWidget(),
              SizedBox(height: D.sizeXXLarge),
            ],
          ),
        ),
      ),
    );
  }
}
