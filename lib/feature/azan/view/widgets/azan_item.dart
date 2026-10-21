import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/feature/azan/logic/models/azan.dart';
import 'package:great_quran/feature/azan/logic/models/timings.dart';
import 'package:intl/intl.dart';

class AzanItem extends StatelessWidget {
  final Azan data;
  const AzanItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final results = data.data.timings;
    final now = DateTime.now();
    final nextPrayerName = _determineNextPrayer(results, now);

    final prayersList = [
      _PrayerMeta(
        name: context.l10n.azanFajr,
        timeStr: results.fajr,
        icon: Icons.brightness_2_rounded,
        accentColor: const Color(0xFF1E88E5),
      ),
      _PrayerMeta(
        name: context.l10n.azanSunrise,
        timeStr: results.sunrise,
        icon: Icons.wb_twilight_rounded,
        accentColor: const Color(0xFFFB8C00),
      ),
      _PrayerMeta(
        name: context.l10n.azanDhuhr,
        timeStr: results.dhuhr,
        icon: Icons.wb_sunny_rounded,
        accentColor: const Color(0xFFFBC02D),
      ),
      _PrayerMeta(
        name: context.l10n.azanAsr,
        timeStr: results.asr,
        icon: Icons.filter_drama_rounded,
        accentColor: const Color(0xFFF57C00),
      ),
      _PrayerMeta(
        name: context.l10n.azanMaghrib,
        timeStr: results.maghrib,
        icon: Icons.nights_stay_outlined,
        accentColor: const Color(0xFFE53935),
      ),
      _PrayerMeta(
        name: context.l10n.azanIsha,
        timeStr: results.isha,
        icon: Icons.nightlight_round,
        accentColor: const Color(0xFF5E35B1),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: D.sizeMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "مواقيت الصلوات الخمس والشروق",
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "توقيت محلي دقيق",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          ...prayersList.map((p) {
            final parsedTime = _parseTime(p.timeStr, now);
            final isNext = p.name == nextPrayerName;
            final isPast = parsedTime != null && parsedTime.isBefore(now);

            return PrayerCardWidget(
              name: p.name,
              timeStr: p.timeStr,
              icon: p.icon,
              accentColor: p.accentColor,
              isNext: isNext,
              isPast: isPast && !isNext,
            );
          }),
        ],
      ),
    );
  }

  String _determineNextPrayer(Timings timings, DateTime now) {
    final prayers = [
      MapEntry("الفجر", timings.fajr),
      MapEntry("الشروق", timings.sunrise),
      MapEntry("الظهر", timings.dhuhr),
      MapEntry("العصر", timings.asr),
      MapEntry("المغرب", timings.maghrib),
      MapEntry("العشاء", timings.isha),
    ];

    for (final entry in prayers) {
      final parsed = _parseTime(entry.value, now);
      if (parsed != null && parsed.isAfter(now)) {
        return entry.key;
      }
    }
    return "الفجر";
  }

  DateTime? _parseTime(String timeStr, DateTime now) {
    try {
      final clean = timeStr.split(' ').first.trim();
      final parts = clean.split(':');
      return DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
    } catch (_) {
      return null;
    }
  }
}

class _PrayerMeta {
  final String name;
  final String timeStr;
  final IconData icon;
  final Color accentColor;

  const _PrayerMeta({
    required this.name,
    required this.timeStr,
    required this.icon,
    required this.accentColor,
  });
}

class PrayerCardWidget extends StatelessWidget {
  final String name;
  final String timeStr;
  final IconData icon;
  final Color accentColor;
  final bool isNext;
  final bool isPast;

  const PrayerCardWidget({
    super.key,
    required this.name,
    required this.timeStr,
    required this.icon,
    required this.accentColor,
    required this.isNext,
    required this.isPast,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;
    final surface = context.colorScheme.surface;

    DateTime? timeDate;
    try {
      final clean = timeStr.split(' ').first.trim();
      final parts = clean.split(':');
      final now = DateTime.now();
      timeDate = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
    } catch (_) {}

    final formatted =
        timeDate != null ? DateFormat.jm().format(timeDate) : timeStr;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isNext ? primary.withValues(alpha: 0.08) : surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isNext
              ? primary
              : Colors.grey.withValues(alpha: isPast ? 0.12 : 0.22),
          width: isNext ? 1.8 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isNext
                ? primary.withValues(alpha: 0.18)
                : Colors.black.withValues(alpha: 0.02),
            blurRadius: isNext ? 10 : 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: D.sizeMedium,
          vertical: 12,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isNext
                    ? primary
                    : accentColor.withValues(alpha: isPast ? 0.08 : 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 22,
                color: isNext
                    ? Colors.white
                    : isPast
                        ? accentColor.withValues(alpha: 0.5)
                        : accentColor,
              ),
            ),
            const SizedBox(width: D.sizeMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight:
                              isNext ? FontWeight.bold : FontWeight.w600,
                          fontSize: 16,
                          color: isNext
                              ? primary
                              : isPast
                                  ? Colors.grey.shade600
                                  : null,
                        ),
                      ),
                      if (isNext) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            "الصلاة القادمة",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (isPast)
                    Text(
                      "انقضى موعدها",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isNext
                    ? primary.withValues(alpha: 0.12)
                    : Colors.grey.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                formatted,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isNext
                      ? primary
                      : isPast
                          ? Colors.grey.shade600
                          : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
