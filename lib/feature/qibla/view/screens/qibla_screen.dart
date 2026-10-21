import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:great_quran/core/assets/assets_manager.dart';
import 'package:great_quran/core/helpers/ui_helpers.dart';
import 'package:great_quran/core/widgets/error_widget.dart';
import 'package:great_quran/core/widgets/loading_widget.dart';
import 'package:great_quran/feature/qibla/logic/providers/qibla_provider.dart';
import 'package:great_quran/feature/qibla/view/widgets/qibla_bottom_bar.dart';
import 'package:great_quran/feature/qibla/view/widgets/qibla_compass_dial.dart';
import 'package:great_quran/feature/qibla/view/widgets/qibla_fallback_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class QiblaScreen extends ConsumerStatefulWidget {
  const QiblaScreen({super.key});

  @override
  ConsumerState<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends ConsumerState<QiblaScreen> {
  @override
  void initState() {
    super.initState();
    UiHelper.postBuild((_) {
      ref.read(QiblaDirectionNotifier.provider.notifier).fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(QiblaDirectionNotifier.provider);

    return Scaffold(
      backgroundColor: const Color(0xFF002B26),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF003833),
              Color(0xFF00544B),
              Color(0xFF002924),
            ],
          ),
        ),
        child: SafeArea(
          child: state.when(
            data: (qiblaDirection) {
              return QiblaCompassView(qiblaDirection: qiblaDirection);
            },
            loading: () => const LoadingWidget(),
            error: (err, stack) => CustomErrorWidget(
              errorMsg: err.toString(),
              onRefresh: () {
                ref.read(QiblaDirectionNotifier.provider.notifier).fetchData();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class QiblaCompassView extends ConsumerWidget {
  final double qiblaDirection;

  const QiblaCompassView({
    super.key,
    required this.qiblaDirection,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compassState = ref.watch(compassStreamProvider);

    return compassState.when(
      loading: () => const LoadingWidget(),
      error: (e, s) => Column(
        children: [
          const QiblaTopBarWidget(isAligned: false),
          Expanded(
            child: QiblaNoSensorFallbackWidget(
              qiblaDirection: qiblaDirection,
            ),
          ),
          const QiblaBottomBar(isCalibrated: false),
        ],
      ),
      data: (event) {
        final heading = event.heading ?? 0.0;
        final diff = (heading - qiblaDirection).abs();
        final isAligned = diff <= 3.0 || diff >= 357.0;

        if (isAligned) {
          HapticFeedback.selectionClick();
        }

        return Column(
          children: [
            QiblaTopBarWidget(isAligned: isAligned),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    QiblaCompassDial(
                      heading: heading,
                      qiblaDirection: qiblaDirection,
                      isAligned: isAligned,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "${heading.round()}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        fontFamily: 'sans-serif',
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "الاتجاه التقريبي للقبلة في",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "موقعك الحالي ${qiblaDirection.round()}°",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            QiblaBottomBar(isCalibrated: isAligned),
          ],
        );
      },
    );
  }
}

class QiblaTopBarWidget extends StatelessWidget {
  final bool isAligned;

  const QiblaTopBarWidget({super.key, required this.isAligned});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.close_rounded,
                  color: Colors.white, size: 26),
              tooltip: "إغلاق",
              onPressed: () => Navigator.pop(context),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isAligned
                  ? Colors.greenAccent.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.1),
              boxShadow: isAligned
                  ? [
                      BoxShadow(
                        color: Colors.greenAccent.withValues(alpha: 0.5),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Image.asset(
              ImageAssets.kabaa,
              width: 32,
              height: 32,
              color: isAligned ? Colors.greenAccent : Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
