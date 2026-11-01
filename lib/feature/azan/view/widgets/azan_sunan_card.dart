import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/routes/routes_manager.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/feature/azan/logic/models/timings.dart';
import 'package:intl/intl.dart';

class AzanSunanCard extends StatelessWidget {
  final Timings timings;

  const AzanSunanCard({
    super.key,
    required this.timings,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: D.sizeMedium,
        vertical: D.sizeSmall,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(D.sizeLarge),
        border: Border.all(
          color: primary.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              D.sizeLarge,
              D.sizeLarge,
              D.sizeLarge,
              D.sizeSmall,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.nights_stay_rounded,
                    color: primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: D.sizeSmall),
                Text(
                  "مواقيت السنن وقيام الليل",
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          SunanTimeRowWidget(
            title: "الثلث الأخير (قيام الليل)",
            subtitle: "أفضل أوقات النوافل واستجابة الدعاء",
            timeStr: timings.lastthird,
            icon: Icons.star_rounded,
            iconColor: const Color(0xFFE65100),
          ),
          const Divider(height: 1, indent: D.sizeLarge, endIndent: D.sizeLarge),
          SunanTimeRowWidget(
            title: "منتصف الليل الشرعي",
            subtitle: "نهاية وقت صلاة العشاء المختار",
            timeStr: timings.midnight,
            icon: Icons.dark_mode_rounded,
            iconColor: const Color(0xFF3949AB),
          ),
          const Divider(height: 1, indent: D.sizeLarge, endIndent: D.sizeLarge),
          SunanTimeRowWidget(
            title: "صلاة الضحى (الأوابين)",
            subtitle: "تبدأ بعد الشروق بربع ساعة حتى الزوال",
            timeStr: _calculateDuha(timings.sunrise),
            icon: Icons.wb_sunny_outlined,
            iconColor: const Color(0xFFF57F17),
          ),
          const SizedBox(height: D.sizeSmall),
        ],
      ),
    );
  }

  String _calculateDuha(String sunriseStr) {
    try {
      final clean = sunriseStr.split(' ').first.trim();
      final parts = clean.split(':');
      final dt = DateTime(2026, 1, 1, int.parse(parts[0]), int.parse(parts[1]))
          .add(const Duration(minutes: 15));
      return DateFormat('HH:mm').format(dt);
    } catch (_) {
      return sunriseStr;
    }
  }
}

class SunanTimeRowWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String timeStr;
  final IconData icon;
  final Color iconColor;

  const SunanTimeRowWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.timeStr,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    String formattedTime = timeStr;
    try {
      final clean = timeStr.split(' ').first.trim();
      final parts = clean.split(':');
      final dt = DateTime(2026, 1, 1, int.parse(parts[0]), int.parse(parts[1]));
      formattedTime = DateFormat.jm().format(dt);
    } catch (_) {}

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: D.sizeLarge,
        vertical: 10,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: D.sizeMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              formattedTime,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QiblaAndDuaBannerWidget extends StatelessWidget {
  const QiblaAndDuaBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: D.sizeMedium,
        vertical: D.sizeSmall,
      ),
      padding: const EdgeInsets.all(D.sizeLarge),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(D.sizeLarge),
        border: Border.all(
          color: primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.explore_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: D.sizeMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "اتجاه القبلة الشريفة",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "تحديد دقيق باتجاه الكعبة المشرفة بمكة المكرمة",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => context.push(Routes.qiblaRoute),
                icon: const Icon(Icons.navigation_rounded, size: 16),
                label: const Text(
                  "فتح البوصلة",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: D.sizeMedium),
          Container(
            padding: const EdgeInsets.all(D.sizeMedium),
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: BorderRadius.circular(D.sizeMedium),
              border: Border.all(
                color: Colors.grey.withValues(alpha: 0.15),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.format_quote_rounded,
                      color: primary,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "دعاء ما بعد الأذان",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  "«اللَّهُمَّ رَبَّ هَذِهِ الدَّعْوَةِ التَّامَّةِ، وَالصَّلَاةِ الْقَائِمَةِ، آتِ مُحَمَّداً الْوَسِيلَةَ وَالْفَضِيلَةَ، وَابْعَثْهُ مَقَاماً مَحْمُوداً الَّذِي وَعَدْتَهُ»",
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.6,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
