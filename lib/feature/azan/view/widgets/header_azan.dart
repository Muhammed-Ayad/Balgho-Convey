import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/routes/routes_manager.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/feature/azan/logic/models/azan.dart';
import 'package:great_quran/feature/settings/logic/models/azan_sound_option.dart';
import 'package:great_quran/feature/settings/logic/providers/azan_settings_provider.dart';
import 'package:great_quran/feature/settings/view/widgets/daylight_saving_sheet.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class HeaderAzan extends ConsumerStatefulWidget {
  final Azan azan;
  const HeaderAzan(this.azan, {super.key});

  @override
  ConsumerState<HeaderAzan> createState() => _HeaderAzanState();
}

class _HeaderAzanState extends ConsumerState<HeaderAzan> {
  Timer? _timer;
  Duration _remaining = Duration.zero;
  String _nextPrayerName = "الفجر";
  String _nextPrayerTimeStr = "";

  @override
  void initState() {
    super.initState();
    _updateCountdown();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        _updateCountdown();
      }
    });
  }

  @override
  void didUpdateWidget(covariant HeaderAzan oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateCountdown() {
    final timings = widget.azan.data.timings;
    final now = DateTime.now();

    final prayers = [
      MapEntry("الفجر", timings.fajr),
      MapEntry("الشروق", timings.sunrise),
      MapEntry("الظهر", timings.dhuhr),
      MapEntry("العصر", timings.asr),
      MapEntry("المغرب", timings.maghrib),
      MapEntry("العشاء", timings.isha),
    ];

    DateTime? nextTarget;
    String nextName = "الفجر";
    String nextTimeStr = timings.fajr;

    for (final entry in prayers) {
      final parsed = _parseToday(entry.value, now);
      if (parsed != null && parsed.isAfter(now)) {
        nextTarget = parsed;
        nextName = entry.key;
        nextTimeStr = entry.value;
        break;
      }
    }

    if (nextTarget == null) {
      final tomorrow = now.add(const Duration(days: 1));
      nextTarget = _parseToday(timings.fajr, tomorrow);
      nextName = "الفجر";
      nextTimeStr = timings.fajr;
    }

    final diff =
        nextTarget != null ? nextTarget.difference(now) : Duration.zero;

    setState(() {
      _remaining = diff.isNegative ? Duration.zero : diff;
      _nextPrayerName = nextName;
      _nextPrayerTimeStr = nextTimeStr;
    });
  }

  DateTime? _parseToday(String timeStr, DateTime date) {
    try {
      final clean = timeStr.split(' ').first.trim();
      final parts = clean.split(':');
      return DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;
    final hijri = widget.azan.data.date.hijri;
    final azanState = ref.watch(AzanSettingsNotifier.provider);
    final currentDstMode =
        azanState.valueOrNull?.daylightSavingMode ?? DaylightSavingMode.auto;

    final hours = _remaining.inHours.toString().padLeft(2, '0');
    final minutes = (_remaining.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_remaining.inSeconds % 60).toString().padLeft(2, '0');
    final countdownStr = "$hours:$minutes:$seconds";

    String nextFormattedTime = _nextPrayerTimeStr;
    try {
      final clean = _nextPrayerTimeStr.split(' ').first.trim();
      final parts = clean.split(':');
      final dt = DateTime(2026, 1, 1, int.parse(parts[0]), int.parse(parts[1]));
      nextFormattedTime = DateFormat.jm().format(dt);
    } catch (_) {}

    return Container(
      margin: const EdgeInsets.all(D.sizeMedium),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primary,
            const Color(0xFF00382B),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: -20,
            bottom: -20,
            child: Icon(
              Icons.mosque_rounded,
              size: 150,
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(D.sizeLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${hijri.weekday.ar}، ${hijri.day} ${hijri.month.en} ${hijri.year} هـ",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.azan.data.date.readable,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: "إعدادات وصوت الأذان",
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.15),
                      ),
                      icon: const Icon(
                        Icons.settings_suggest_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => context.push(Routes.azanSettingsRoute),
                    ),
                  ],
                ),
                const SizedBox(height: D.sizeMedium),
                Container(
                  padding: const EdgeInsets.all(D.sizeMedium),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withValues(alpha: 0.25),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.access_alarm_rounded,
                                  color: Colors.amberAccent,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "الصلاة القادمة: صلاة $_nextPrayerName",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            nextFormattedTime,
                            style: const TextStyle(
                              color: Colors.amberAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "متبقي على موعد الأذان",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 12,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              countdownStr,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: D.sizeMedium),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DstQuickSelectorChip(
                      currentMode: currentDstMode,
                      onTap: () {
                        DaylightSavingBottomSheet.show(context, currentDstMode);
                      },
                    ),
                    const CalculationBadgeWidget(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DstQuickSelectorChip extends StatelessWidget {
  final DaylightSavingMode currentMode;
  final VoidCallback onTap;

  const DstQuickSelectorChip({
    super.key,
    required this.currentMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                currentMode == DaylightSavingMode.summer
                    ? Icons.wb_sunny_rounded
                    : currentMode == DaylightSavingMode.winter
                        ? Icons.ac_unit_rounded
                        : Icons.brightness_auto_rounded,
                color: Colors.amberAccent,
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                currentMode.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_drop_down_rounded,
                color: Colors.white70,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CalculationBadgeWidget extends StatelessWidget {
  const CalculationBadgeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.gps_fixed_rounded, size: 11, color: Colors.white70),
          SizedBox(width: 5),
          Text(
            "مصر • حساب دقيق بدون إنترنت",
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
