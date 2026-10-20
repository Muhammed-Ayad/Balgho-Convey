import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:great_quran/core/assets/assets_manager.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/helpers/ui_helpers.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/core/widgets/custom_app_bar.dart';
import 'package:great_quran/core/widgets/error_widget.dart';
import 'package:great_quran/core/widgets/loading_widget.dart';
import 'package:great_quran/feature/qibla/logic/providers/qibla_provider.dart';
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
    return Scaffold(
      appBar: CustomAppBar(
        title: context.l10n.titleQibla,
      ),
      body: Consumer(builder: (context, ref, _) {
        final state = ref.watch(QiblaDirectionNotifier.provider);

        return state.when(
          data: (qiblaDirection) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: D.sizeXLarge,
                ),
                child: Consumer(builder: (context, ref, _) {
                  final compassState = ref.watch(compassStreamProvider);

                  return compassState.when(
                      data: (event) {
                        if (event.heading?.ceilToDouble() ==
                            qiblaDirection.ceilToDouble()) {
                          "Vibrate".log();
                          HapticFeedback.vibrate();
                        }
                        final compassAngle = 0.0175 * (event.heading ?? 0) * -1;
                        final qiblaAngle =
                            (qiblaDirection * 0.0175) + compassAngle;
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Transform.rotate(
                              angle: qiblaAngle,
                              child: Image.asset(ImageAssets.qibla),
                            ),
                            Transform.rotate(
                              angle: compassAngle,
                              child: Image.asset(ImageAssets.compass),
                            ),
                            Positioned(
                              right: 0,
                              left: 0,
                              top: -30,
                              child: Icon(
                                Icons.arrow_upward_rounded,
                                size: 40,
                                color: context.colorScheme.primary,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              left: 0,
                              top: -60,
                              child: Text(
                                "${event.heading?.ceilToDouble()} °",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: context.colorScheme.primary,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              left: 0,
                              top: -90,
                              child: Text(
                                "طابق أيقونة الكعبة مع السهم لتحديد اتجاه القبلة",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: context.colorScheme.primary,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () => const LoadingWidget(),
                      error: (e, s) => const CustomErrorWidget());
                }),
              ),
            );
          },
          loading: () => const LoadingWidget(),
          error: (err, stack) => CustomErrorWidget(
            errorMsg: err.toString(),
            onRefresh: () {
              UiHelper.postBuild((_) {
                ref.read(QiblaDirectionNotifier.provider.notifier).fetchData();
              });
            },
          ),
        );
      }),
    );
  }
}
