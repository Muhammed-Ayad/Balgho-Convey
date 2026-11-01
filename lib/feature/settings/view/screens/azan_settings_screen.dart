import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/core/widgets/custom_app_bar.dart';
import 'package:great_quran/core/widgets/error_widget.dart';
import 'package:great_quran/core/widgets/loading_widget.dart';
import 'package:great_quran/feature/settings/logic/models/azan_sound_option.dart';
import 'package:great_quran/feature/settings/logic/providers/azan_settings_provider.dart';
import 'package:great_quran/feature/settings/view/widgets/daylight_saving_sheet.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AzanSettingsScreen extends ConsumerStatefulWidget {
  const AzanSettingsScreen({super.key});

  @override
  ConsumerState<AzanSettingsScreen> createState() => _AzanSettingsScreenState();
}

class _AzanSettingsScreenState extends ConsumerState<AzanSettingsScreen> {
  @override
  void dispose() {
    ref.read(AzanSettingsNotifier.provider.notifier).stopAudioPreview();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(AzanSettingsNotifier.provider);
    final notifier = ref.read(AzanSettingsNotifier.provider.notifier);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        notifier.stopAudioPreview();
      },
      child: Scaffold(
        appBar: const CustomAppBar(
          title: "تنبيهات وصوت الأذان",
        ),
        body: state.when(
          data: (prefs) {
            return ListView(
              padding: const EdgeInsets.all(D.sizeMedium),
              children: [
                AzanMasterSwitchCard(
                  isEnabled: prefs.isEnabled,
                  onChanged: (val) => notifier.toggleEnabled(val),
                ),
                const SizedBox(height: D.sizeMedium),
                AzanDaylightSavingCard(
                  currentMode: prefs.daylightSavingMode,
                  onTap: () {
                    DaylightSavingBottomSheet.show(
                        context, prefs.daylightSavingMode);
                  },
                ),
                const SizedBox(height: D.sizeMedium),
                AzanFlipToMuteCard(
                  isEnabled: prefs.flipToMute,
                  onChanged: (val) => notifier.toggleFlipToMute(val),
                ),
                const SizedBox(height: D.sizeMedium),
                const AzanSectionTitle(title: "اختيار صوت المؤذن"),
                ...AzanVoice.values.map((voice) {
                  final isSelected = prefs.selectedVoice == voice;
                  final isPlayingThis = notifier.currentlyPlayingVoice == voice;

                  return AzanVoiceOptionCard(
                    voice: voice,
                    isSelected: isSelected,
                    isPlaying: isPlayingThis,
                    onSelect: () => notifier.setVoice(voice),
                    onTogglePreview: () => notifier.toggleVoicePreview(voice),
                  );
                }),
                const SizedBox(height: D.sizeMedium),
                const AzanSectionTitle(title: "تفعيل التنبيه لكل صلاة"),
                AzanPrayerTogglesCard(
                  prefs: prefs,
                  onTogglePrayer: (prayer, val) =>
                      notifier.togglePrayer(prayer, val),
                ),
                const SizedBox(height: D.sizeXXLarge),
              ],
            );
          },
          loading: () => const LoadingWidget(),
          error: (err, stack) => CustomErrorWidget(
            errorMsg: err.toString(),
            onRefresh: () => notifier.loadPreferences(),
          ),
        ),
      ),
    );
  }
}

class AzanFlipToMuteCard extends StatelessWidget {
  final bool isEnabled;
  final ValueChanged<bool> onChanged;

  const AzanFlipToMuteCard({
    super.key,
    required this.isEnabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(D.sizeLarge),
        border: Border.all(
          color: primary.withValues(alpha: 0.15),
        ),
      ),
      child: SwitchListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(D.sizeLarge),
        ),
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.screen_rotation_alt_rounded,
            color: primary,
            size: 22,
          ),
        ),
        title: const Text(
          "كتم الأذان عند قلب الهاتف",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: const Text(
          "إيقاف صوت الأذان تلقائياً بمجرد وضع الهاتف وشاشته للأسفل",
          style: TextStyle(fontSize: 12),
        ),
        activeThumbColor: primary,
        value: isEnabled,
        onChanged: onChanged,
      ),
    );
  }
}

class AzanDaylightSavingCard extends StatelessWidget {
  final DaylightSavingMode currentMode;
  final VoidCallback onTap;

  const AzanDaylightSavingCard({
    super.key,
    required this.currentMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(D.sizeLarge),
        border: Border.all(
          color: primary.withValues(alpha: 0.15),
        ),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(D.sizeLarge),
        ),
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            currentMode == DaylightSavingMode.summer
                ? Icons.wb_sunny_rounded
                : currentMode == DaylightSavingMode.winter
                    ? Icons.ac_unit_rounded
                    : Icons.brightness_auto_rounded,
            color: primary,
            size: 22,
          ),
        ),
        title: const Text(
          "التوقيت الصيفي / الشتوي",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          "الوضع الحالي: ${currentMode.title} (${currentMode.description})",
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                currentMode.title,
                style: TextStyle(
                  color: primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14),
          ],
        ),
      ),
    );
  }
}

class AzanMasterSwitchCard extends StatelessWidget {
  final bool isEnabled;
  final ValueChanged<bool> onChanged;

  const AzanMasterSwitchCard({
    super.key,
    required this.isEnabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: D.sizeMedium,
        vertical: D.sizeSmall,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(D.sizeLarge),
        border: Border.all(
          color: primary.withValues(alpha: 0.15),
        ),
      ),
      child: SwitchListTile(
        title: const Text(
          "تفعيل إشعارات الأذان",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: const Text(
          "تنبيه صوتي وإشعار عند حلول موعد الصلاة",
          style: TextStyle(fontSize: 12),
        ),
        activeThumbColor: primary,
        value: isEnabled,
        onChanged: onChanged,
      ),
    );
  }
}

class AzanSectionTitle extends StatelessWidget {
  final String title;

  const AzanSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: primary,
        ),
      ),
    );
  }
}

class AzanVoiceOptionCard extends StatelessWidget {
  final AzanVoice voice;
  final bool isSelected;
  final bool isPlaying;
  final VoidCallback onSelect;
  final VoidCallback onTogglePreview;

  const AzanVoiceOptionCard({
    super.key,
    required this.voice,
    required this.isSelected,
    required this.isPlaying,
    required this.onSelect,
    required this.onTogglePreview,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(D.sizeMedium),
        border: Border.all(
          color: isSelected ? primary : primary.withValues(alpha: 0.1),
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(D.sizeMedium),
          onTap: onSelect,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: D.sizeMedium,
              vertical: 12.0,
            ),
            child: Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? primary : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: isSelected
                      ? Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primary,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: D.sizeMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        voice.title,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        voice.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (voice.sampleUrl.isNotEmpty) ...[
                  IconButton(
                    icon: Icon(
                      isPlaying
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_fill_rounded,
                      color: primary,
                      size: 28,
                    ),
                    tooltip: isPlaying ? "إيقاف المعاينة" : "معاينة الصوت",
                    onPressed: onTogglePreview,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AzanPrayerTogglesCard extends StatelessWidget {
  final AzanNotificationPreferences prefs;
  final Function(String, bool) onTogglePrayer;

  const AzanPrayerTogglesCard({
    super.key,
    required this.prefs,
    required this.onTogglePrayer,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    final prayers = [
      {'key': 'fajr', 'name': 'صلاة الفجر', 'val': prefs.fajr},
      {'key': 'dhuhr', 'name': 'صلاة الظهر', 'val': prefs.dhuhr},
      {'key': 'asr', 'name': 'صلاة العصر', 'val': prefs.asr},
      {'key': 'maghrib', 'name': 'صلاة المغرب', 'val': prefs.maghrib},
      {'key': 'isha', 'name': 'صلاة العشاء', 'val': prefs.isha},
    ];

    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(D.sizeLarge),
        border: Border.all(
          color: primary.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        children: prayers.map((p) {
          final isLast = p == prayers.last;
          return Column(
            children: [
              SwitchListTile(
                title: Text(
                  p['name'] as String,
                  style: const TextStyle(fontSize: 14),
                ),
                activeThumbColor: primary,
                value: p['val'] as bool,
                onChanged: (val) => onTogglePrayer(p['key'] as String, val),
              ),
              if (!isLast) const Divider(height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }
}
