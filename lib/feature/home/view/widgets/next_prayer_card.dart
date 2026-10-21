import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/helpers/ui_helpers.dart';
import 'package:great_quran/core/routes/routes_manager.dart';
import 'package:great_quran/core/services/home_widget_sync_service.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/feature/azan/logic/providers/azan_provider.dart';
import 'package:great_quran/feature/home/logic/providers/next_prayer_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NextPrayerCard extends ConsumerStatefulWidget {
  const NextPrayerCard({super.key});

  @override
  ConsumerState<NextPrayerCard> createState() => _NextPrayerCardState();
}

class _NextPrayerCardState extends ConsumerState<NextPrayerCard> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (!Platform.environment.containsKey('FLUTTER_TEST')) {
      _timer = Timer.periodic(const Duration(minutes: 1), (_) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nextPrayer = ref.watch(nextPrayerProvider);
    final azanState = ref.watch(AzanTimeNotifier.provider);
    final primary = context.colorScheme.primary;

    if (nextPrayer != null) {
      UiHelper.postBuild((_) {
        ref.read(HomeWidgetSyncService.provider).syncPrayerData(
              prayerName: nextPrayer.prayerName,
              prayerTime: nextPrayer.formattedTime,
              remainingFormatted: nextPrayer.remainingFormatted,
              hijriDate: nextPrayer.hijriDate,
            );
      });
    }

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: D.sizeMedium,
        vertical: D.sizeSmall,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(D.sizeLarge),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            primary,
            const Color(0xFF005B5B),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(D.sizeLarge),
          onTap: () {
            context.push(Routes.azanRoute);
          },
          child: Padding(
            padding: const EdgeInsets.all(D.sizeLarge),
            child: azanState.when(
              loading: () => const NextPrayerLoadingWidget(),
              error: (_, __) => const NextPrayerErrorWidget(),
              data: (_) {
                if (nextPrayer == null) {
                  return const NextPrayerErrorWidget();
                }
                return NextPrayerContentWidget(nextPrayer: nextPrayer);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class NextPrayerContentWidget extends StatelessWidget {
  final NextPrayerModel nextPrayer;

  const NextPrayerContentWidget({
    super.key,
    required this.nextPrayer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.access_time_filled_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  "الصلاة القادمة",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                nextPrayer.hijriDate,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: D.sizeMedium),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "صلاة ${nextPrayer.prayerName}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "الأذان: ${nextPrayer.formattedTime}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.hourglass_top_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "باقي ${nextPrayer.remainingFormatted}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class NextPrayerLoadingWidget extends StatelessWidget {
  const NextPrayerLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 60,
      child: Center(
        child: Text(
          "جاري احتساب موعد الصلاة...",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class NextPrayerErrorWidget extends StatelessWidget {
  const NextPrayerErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "اضغط لعرض مواقيت الصلاة",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.white.withValues(alpha: 0.8),
          size: 16,
        ),
      ],
    );
  }
}
