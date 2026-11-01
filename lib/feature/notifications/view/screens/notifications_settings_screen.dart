import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:great_quran/core/services/local_notification_service.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/core/widgets/custom_app_bar.dart';
import 'package:great_quran/core/widgets/error_widget.dart';
import 'package:great_quran/core/widgets/loading_widget.dart';
import 'package:great_quran/feature/notifications/logic/models/notification_settings_model.dart';
import 'package:great_quran/feature/notifications/logic/providers/notification_settings_provider.dart';
import 'package:great_quran/feature/notifications/view/widgets/exact_alarm_rationale_dialog.dart';
import 'package:great_quran/feature/notifications/view/widgets/exact_alarm_warning_banner.dart';
import 'package:great_quran/feature/notifications/view/widgets/notification_category_container.dart';
import 'package:great_quran/feature/notifications/view/widgets/notification_diagnostics_card.dart';
import 'package:great_quran/feature/notifications/view/widgets/notification_master_card.dart';
import 'package:great_quran/feature/notifications/view/widgets/notification_switch_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationsSettingsScreen extends ConsumerStatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  ConsumerState<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends ConsumerState<NotificationsSettingsScreen>
    with WidgetsBindingObserver {
  bool _canScheduleExact = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(NotificationSettingsNotifier.provider.notifier)
          .requestPermissions();
      _checkExactStatus();
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
      _checkExactStatus(onResumed: true);
    }
  }

  Future<void> _checkExactStatus({bool onResumed = false}) async {
    try {
      final notifService = ref.read(LocalNotificationService.provider);
      final canExact = await notifService.canScheduleExactNotifications();
      if (!mounted) return;

      final previousCanExact = _canScheduleExact;
      setState(() {
        _canScheduleExact = canExact;
      });

      if (onResumed && !previousCanExact && canExact) {
        Fluttertoast.showToast(
          msg:
              "تم تفعيل إذن المنبهات الدقيقة بنجاح! تم تحديث مواقيت الإشعارات ⏰",
          backgroundColor: const Color(0xFF00695C),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
        final notifier =
            ref.read(NotificationSettingsNotifier.provider.notifier);
        await notifier.requestPermissionsAndSync();
        ref.invalidate(notificationDiagnosticsProvider);
      }
    } catch (e, stack) {
      debugPrint(
          "NotificationsSettingsScreen: Error checking exact alarm status: $e\n$stack");
    }
  }

  Future<void> _promptExactAlarmDialog() async {
    final shouldOpen = await ExactAlarmRationaleDialog.show(context);
    if (!mounted) return;
    if (shouldOpen == true) {
      final notifier = ref.read(NotificationSettingsNotifier.provider.notifier);
      await notifier.openExactAlarmSettings();
    }
  }

  Future<void> _handleMasterToggle(bool val) async {
    final notifier = ref.read(NotificationSettingsNotifier.provider.notifier);
    if (val && !_canScheduleExact) {
      final hasPrompted = await notifier.isExactAlarmPromptShown();
      if (!hasPrompted) {
        await notifier.setExactAlarmPromptShown(true);
        await _promptExactAlarmDialog();
      }
    }
    await notifier.toggleAllNotifications(val);
  }

  Future<void> _handlePrayerCategoryToggle(bool val) async {
    final notifier = ref.read(NotificationSettingsNotifier.provider.notifier);
    if (val && !_canScheduleExact) {
      final hasPrompted = await notifier.isExactAlarmPromptShown();
      if (!hasPrompted) {
        await notifier.setExactAlarmPromptShown(true);
        await _promptExactAlarmDialog();
      }
    }
    await notifier.togglePrayerCategory(val);
  }

  Future<void> _handleAzkarCategoryToggle(bool val) async {
    final notifier = ref.read(NotificationSettingsNotifier.provider.notifier);
    if (val && !_canScheduleExact) {
      final hasPrompted = await notifier.isExactAlarmPromptShown();
      if (!hasPrompted) {
        await notifier.setExactAlarmPromptShown(true);
        await _promptExactAlarmDialog();
      }
    }
    await notifier.toggleAzkarCategory(val);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(NotificationSettingsNotifier.provider);
    final notifier = ref.read(NotificationSettingsNotifier.provider.notifier);

    return Scaffold(
      appBar: const CustomAppBar(
        title: "مركز الإشعارات والتنبيهات",
      ),
      body: state.when(
        data: (settings) {
          final isMasterOn = settings.allNotificationsEnabled;

          return ListView(
            padding: const EdgeInsets.all(D.sizeMedium),
            children: [
              NotificationMasterCard(
                isEnabled: isMasterOn,
                onChanged: _handleMasterToggle,
              ),
              if (isMasterOn) ...[
                if (kDebugMode) const NotificationDiagnosticsCard(),
                if (!_canScheduleExact)
                  ExactAlarmWarningBanner(
                    onEnableExact: _promptExactAlarmDialog,
                  ),
                _PrayerNotificationsSection(
                  settings: settings,
                  notifier: notifier,
                  onCategoryToggle: _handlePrayerCategoryToggle,
                ),
                _AzkarNotificationsSection(
                  settings: settings,
                  notifier: notifier,
                  onCategoryToggle: _handleAzkarCategoryToggle,
                ),
                _DailyRemindersSection(
                  settings: settings,
                  notifier: notifier,
                ),
                _SunanNotificationsSection(
                  settings: settings,
                  notifier: notifier,
                ),
                _OccasionsNotificationsSection(
                  settings: settings,
                  notifier: notifier,
                ),
              ],
              const SizedBox(height: D.sizeLarge),
            ],
          );
        },
        loading: () => const LoadingWidget(),
        error: (err, _) => CustomErrorWidget(
          errorMsg: err.toString(),
          onRefresh: () => notifier.loadSettings(),
        ),
      ),
    );
  }
}

class _PrayerNotificationsSection extends StatelessWidget {
  final NotificationSettingsModel settings;
  final NotificationSettingsNotifier notifier;
  final ValueChanged<bool> onCategoryToggle;

  const _PrayerNotificationsSection({
    required this.settings,
    required this.notifier,
    required this.onCategoryToggle,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = settings.prayerNotificationsEnabled;

    return NotificationCategoryContainer(
      icon: Icons.mosque_rounded,
      title: "مواقيت الصلوات الخمس",
      subtitle: "تنبيهات بدخول وقت كل صلاة وتذكير مسبق",
      isCategoryEnabled: enabled,
      onCategoryToggle: onCategoryToggle,
      children: [
        NotificationSwitchItem(
          title: "صلاة الفجر",
          icon: Icons.brightness_3_rounded,
          value: settings.fajr,
          isEnabled: enabled,
          onChanged: (val) => notifier.toggleSpecificPrayer('fajr', val),
        ),
        NotificationSwitchItem(
          title: "صلاة الظهر",
          icon: Icons.wb_sunny_rounded,
          value: settings.dhuhr,
          isEnabled: enabled,
          onChanged: (val) => notifier.toggleSpecificPrayer('dhuhr', val),
        ),
        NotificationSwitchItem(
          title: "صلاة العصر",
          icon: Icons.wb_twilight_rounded,
          value: settings.asr,
          isEnabled: enabled,
          onChanged: (val) => notifier.toggleSpecificPrayer('asr', val),
        ),
        NotificationSwitchItem(
          title: "صلاة المغرب",
          icon: Icons.wb_sunny_outlined,
          value: settings.maghrib,
          isEnabled: enabled,
          onChanged: (val) => notifier.toggleSpecificPrayer('maghrib', val),
        ),
        NotificationSwitchItem(
          title: "صلاة العشاء",
          icon: Icons.nightlight_round,
          value: settings.isha,
          isEnabled: enabled,
          onChanged: (val) => notifier.toggleSpecificPrayer('isha', val),
        ),
        const Divider(height: 1, indent: 16, endIndent: 16),
        NotificationSwitchItem(
          title: "تنبيه مسبق قبل الأذان (10 دقائق)",
          subtitle: "تذكير مبكر للاستعداد والوضوء للصلوات",
          icon: Icons.alarm_rounded,
          value: settings.prayerPreReminder,
          isEnabled: enabled,
          onChanged: (val) => notifier.togglePrayerPreReminder(val),
        ),
      ],
    );
  }
}

class _AzkarNotificationsSection extends StatelessWidget {
  final NotificationSettingsModel settings;
  final NotificationSettingsNotifier notifier;
  final ValueChanged<bool> onCategoryToggle;

  const _AzkarNotificationsSection({
    required this.settings,
    required this.notifier,
    required this.onCategoryToggle,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = settings.azkarNotificationsEnabled;

    return NotificationCategoryContainer(
      icon: Icons.auto_stories_rounded,
      title: "الأذكار والتحصين اليومي",
      subtitle: "أذكار الصباح والمساء والنوم والاستيقاظ",
      isCategoryEnabled: enabled,
      onCategoryToggle: onCategoryToggle,
      children: [
        NotificationSwitchItem(
          title: "أذكار الصباح",
          subtitle: "تنبيه يومي الساعة 07:00 صباحاً",
          icon: Icons.wb_sunny_rounded,
          value: settings.morningAzkar,
          isEnabled: enabled,
          onChanged: (val) => notifier.toggleSpecificAzkar('morning', val),
        ),
        NotificationSwitchItem(
          title: "أذكار المساء",
          subtitle: "تنبيه يومي الساعة 05:00 مساءً",
          icon: Icons.nights_stay_rounded,
          value: settings.eveningAzkar,
          isEnabled: enabled,
          onChanged: (val) => notifier.toggleSpecificAzkar('evening', val),
        ),
        NotificationSwitchItem(
          title: "أذكار النوم",
          subtitle: "تنبيه يومي الساعة 10:30 مساءً",
          icon: Icons.bedtime_rounded,
          value: settings.sleepAzkar,
          isEnabled: enabled,
          onChanged: (val) => notifier.toggleSpecificAzkar('sleep', val),
        ),
        NotificationSwitchItem(
          title: "أذكار الاستيقاظ من النوم",
          subtitle: "تنبيه يومي الساعة 06:00 صباحاً",
          icon: Icons.alarm_on_rounded,
          value: settings.wakeUpAzkar,
          isEnabled: enabled,
          onChanged: (val) => notifier.toggleSpecificAzkar('wakeup', val),
        ),
      ],
    );
  }
}

class _DailyRemindersSection extends StatelessWidget {
  final NotificationSettingsModel settings;
  final NotificationSettingsNotifier notifier;

  const _DailyRemindersSection({
    required this.settings,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationCategoryContainer(
      icon: Icons.menu_book_rounded,
      title: "الهدي والتدبر اليومي",
      subtitle: "ذكر وحديث نبوي متجدد يومياً",
      isCategoryEnabled: true,
      children: [
        NotificationSwitchItem(
          title: "ذكر اليوم المبارك",
          subtitle: "تنبيه بذكر مأثور يومياً الساعة 09:00 صباحاً",
          icon: Icons.favorite_border_rounded,
          value: settings.dailyZekrEnabled,
          onChanged: (val) => notifier.toggleDailyZekr(val),
        ),
        NotificationSwitchItem(
          title: "حديث نبوي شريف",
          subtitle: "قبس من السنة النبوية الساعة 01:30 ظهراً",
          icon: Icons.format_quote_rounded,
          value: settings.dailyHadithEnabled,
          onChanged: (val) => notifier.toggleDailyHadith(val),
        ),
      ],
    );
  }
}

class _SunanNotificationsSection extends StatelessWidget {
  final NotificationSettingsModel settings;
  final NotificationSettingsNotifier notifier;

  const _SunanNotificationsSection({
    required this.settings,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = settings.sunanEnabled;

    return NotificationCategoryContainer(
      icon: Icons.stars_rounded,
      title: "السنن والنوافل",
      subtitle: "صلاة الضحى وقيام الليل والوتر",
      isCategoryEnabled: enabled,
      onCategoryToggle: (val) => notifier.toggleSunanCategory(val),
      children: [
        NotificationSwitchItem(
          title: "صلاة الضحى (صلاة الأوابين)",
          subtitle: "تنبيه الساعة 09:30 صباحاً.. صدقة عن مفاصلك",
          icon: Icons.wb_sunny_rounded,
          value: settings.duhaPrayer,
          isEnabled: enabled,
          onChanged: (val) => notifier.toggleDuha(val),
        ),
        NotificationSwitchItem(
          title: "قيام الليل والوتر",
          subtitle: "تنبيه في الثلث الأخير الساعة 03:30 فجراً",
          icon: Icons.dark_mode_rounded,
          value: settings.qiyamNight,
          isEnabled: enabled,
          onChanged: (val) => notifier.toggleQiyam(val),
        ),
      ],
    );
  }
}

class _OccasionsNotificationsSection extends StatelessWidget {
  final NotificationSettingsModel settings;
  final NotificationSettingsNotifier notifier;

  const _OccasionsNotificationsSection({
    required this.settings,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = settings.occasionsEnabled;

    return NotificationCategoryContainer(
      icon: Icons.calendar_month_rounded,
      title: "المناسبات والسنن الدورية",
      subtitle: "سورة الكهف الجمعة وصيام النوافل",
      isCategoryEnabled: enabled,
      onCategoryToggle: (val) => notifier.toggleOccasionsCategory(val),
      children: [
        NotificationSwitchItem(
          title: "سورة الكهف والصلاة على النبي ﷺ",
          subtitle: "تنبيه صباح كل جمعة الساعة 08:30 صباحاً",
          icon: Icons.mosque_outlined,
          value: settings.fridayKahf,
          isEnabled: enabled,
          onChanged: (val) => notifier.toggleFridayKahf(val),
        ),
        NotificationSwitchItem(
          title: "صيام الإثنين والخميس",
          subtitle: "تذكير مساء الأحد والأربعاء بسنة الصيام",
          icon: Icons.restaurant_menu_rounded,
          value: settings.fastingMondayThursday,
          isEnabled: enabled,
          onChanged: (val) => notifier.toggleFastingMondayThursday(val),
        ),
        NotificationSwitchItem(
          title: "صيام الأيام البيض (13، 14، 15)",
          subtitle: "تذكير شهري قبل بدء الأيام القمرية المباركة",
          icon: Icons.circle_outlined,
          value: settings.fastingWhiteDays,
          isEnabled: enabled,
          onChanged: (val) => notifier.toggleFastingWhiteDays(val),
        ),
      ],
    );
  }
}
