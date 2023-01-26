import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/blocs/notifiers/qibla_direction_notifier.dart';
import 'package:great_quran/blocs/state_mix/state_mix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:great_quran/helpers/extensions.dart';

import 'package:great_quran/theme/dimensions.dart';
import 'package:great_quran/resources/assets_manager.dart';
import 'package:great_quran/resources/strings_manager.dart';
import 'package:great_quran/ui/widgets/custom_app_bar.dart';

import '../../helpers/ui_helpers.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';

final compassStream =
    StreamProvider<CompassEvent>((ref) => FlutterCompass.events!);

class QiblaScreen extends ConsumerStatefulWidget {
  const QiblaScreen({Key? key}) : super(key: key);

  @override
  _QiblaScreenState createState() => _QiblaScreenState();
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
      appBar: const CustomAppBar(
        title: AppStrings.qibla,
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
                  final state = ref.watch(compassStream);

                  return state.when(
                      data: (event) {
                        if (event.heading?.ceilToDouble() ==
                            qiblaDirection.ceilToDouble()) {
                          "Vibrate".log();
                          Vibrate.vibrate();
                        }
                        // Calculate the compass image rotation angel
                        final compassAngel = 0.0175 * (event.heading ?? 0) * -1;

                        // Calculate the qibla rotation angel based on the compass
                        final qiblaAngel =
                            (qiblaDirection * 0.0175) + compassAngel;
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // (math.pi / 180 = 0.0175) is essential to convert from degree to radians
                            // as the `angel` property is calculated in radians
                            // * Qibla Needle
                            Transform.rotate(
                              angle: qiblaAngel,
                              child: Image.asset(ImageAssets.qibla),
                            ),

                            // * Compass
                            Transform.rotate(
                              angle: compassAngel,
                              child: Image.asset(ImageAssets.compass),
                            ),

                            // * Arrow UP
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

                            // * Heading degree
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

                            // * Qibla Direction Hint
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
          error: (errorMsg) => CustomErrorWidget(
            errorMsg: errorMsg,
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
