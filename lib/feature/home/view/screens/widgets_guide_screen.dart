import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/services/home_widget_sync_service.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/core/widgets/custom_app_bar.dart';
import 'package:great_quran/feature/daily_zekr/logic/providers/daily_zekr_provider.dart';
import 'package:great_quran/feature/home/logic/providers/next_prayer_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WidgetsGuideScreen extends ConsumerWidget {
  const WidgetsGuideScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nextPrayer = ref.watch(nextPrayerProvider);
    final dailyZekr = ref.watch(dailyZekrProvider);
    final primary = context.colorScheme.primary;

    return Scaffold(
      appBar: const CustomAppBar(
        title: "ودجت الشاشة الرئيسية",
      ),
      body: ListView(
        padding: const EdgeInsets.all(D.sizeMedium),
        children: [
          Container(
            padding: const EdgeInsets.all(D.sizeLarge),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(D.sizeLarge),
              border: Border.all(
                color: primary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.widgets_rounded, size: 36, color: primary),
                const SizedBox(width: D.sizeMedium),
                Expanded(
                  child: Text(
                    "يمكنك وضع ودجت الصلاة والذكر على شاشة هاتفك الرئيسية لتذكيرك الدائم بالصلاة والأذكار دون الحاجة لفتح التطبيق.",
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: D.sizeLarge),
          const WidgetSectionHeader(title: "1. ودجت الصلاة القادمة (مصغر)"),
          const SizedBox(height: D.sizeSmall),
          PrayerWidgetPreviewCard(nextPrayer: nextPrayer),
          const SizedBox(height: D.sizeLarge),
          const WidgetSectionHeader(title: "2. ودجت ذكر اليوم المبارك"),
          const SizedBox(height: D.sizeSmall),
          ZekrWidgetPreviewCard(dailyZekrText: dailyZekr.text),
          const SizedBox(height: D.sizeLarge),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(D.sizeLarge),
                ),
              ),
              icon: const Icon(Icons.sync_rounded),
              label: const Text(
                "تحديث ومزامنة بيانات الودجت الآن",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                if (nextPrayer != null) {
                  await ref.read(HomeWidgetSyncService.provider).syncPrayerData(
                        prayerName: nextPrayer.prayerName,
                        prayerTime: nextPrayer.formattedTime,
                        remainingFormatted: nextPrayer.remainingFormatted,
                        hijriDate: nextPrayer.hijriDate,
                      );
                }
                await ref.read(HomeWidgetSyncService.provider).syncDailyZekr(
                      zekr: dailyZekr.text,
                      fadl: dailyZekr.fadl ?? '',
                    );
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("تم تحديث بيانات الودجت بنجاح ✅"),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: D.sizeLarge),
          const WidgetInstructionsCard(),
          const SizedBox(height: D.sizeXXLarge),
        ],
      ),
    );
  }
}

class WidgetSectionHeader extends StatelessWidget {
  final String title;

  const WidgetSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class PrayerWidgetPreviewCard extends StatelessWidget {
  final NextPrayerModel? nextPrayer;

  const PrayerWidgetPreviewCard({super.key, required this.nextPrayer});

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Center(
      child: Container(
        width: 170,
        height: 160,
        padding: const EdgeInsets.all(D.sizeMedium),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              primary,
              const Color(0xFF004D40),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.access_time_filled_rounded,
                  color: Colors.white70,
                  size: 20,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "القادمة",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nextPrayer?.prayerName ?? "المغرب",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  nextPrayer?.formattedTime ?? "05:45 م",
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Text(
              "متبقي ${nextPrayer?.remainingFormatted ?? '45 دقيقة'}",
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ZekrWidgetPreviewCard extends StatelessWidget {
  final String dailyZekrText;

  const ZekrWidgetPreviewCard({super.key, required this.dailyZekrText});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(D.sizeLarge),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: context.colorScheme.primary.withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.amber,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  "ذكر اليوم المبارك",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: context.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: D.sizeSmall),
            Text(
              dailyZekrText,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class WidgetInstructionsCard extends StatelessWidget {
  const WidgetInstructionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(D.sizeLarge),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(D.sizeLarge),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "طريقة إضافة الودجت إلى شاشة الهاتف:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(height: 8),
          Text(
            "1. اضغط مطولاً على أي مساحة فارغة في شاشة هاتفك الرئيسية.\n"
            "2. اضغط على خيار (Widgets / التطبيقات المصغرة) في أسفل أو أعلى الشاشة.\n"
            "3. ابحث عن تطبيق (بلغوا عني ولو آية) في قائمة التطبيقات.\n"
            "4. اختر حجم الودجت المفضل واسحبه وضعه في المكان الذي تريده.",
            style: TextStyle(fontSize: 13, height: 1.6, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
