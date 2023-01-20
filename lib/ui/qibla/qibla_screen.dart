import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/blocs/notifiers/qibla_direction_notifier.dart';

import 'dart:math' as math;

import 'package:great_quran/theme/dimensions.dart';
import 'package:great_quran/resources/assets_manager.dart';
import 'package:great_quran/resources/strings_manager.dart';
import 'package:great_quran/ui/widgets/custom_app_bar.dart';

import '../../helpers/ui_helpers.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';

class QiblaScreen extends ConsumerStatefulWidget {
  const QiblaScreen({Key? key}) : super(key: key);

  @override
  _QiblaScreenState createState() => _QiblaScreenState();
}

class _QiblaScreenState extends ConsumerState<QiblaScreen> {
  double _direction = 0;

  @override
  void initState() {
    super.initState();

    UiHelper.postBuild((_) {
      ref.read(QiblaDirectionNotifier.provider.notifier).fetchQiblaDirection();
    });
    _getCompassDirection();
  }

  void _getCompassDirection() async {
    FlutterCompass.events!.listen((direction) {
      if (mounted) {
        setState(() {
          _direction = direction.heading!;
        });
      }
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
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: D.sizeXLarge,
                      ),
                      child: Stack(
                        children: [
                          // (math.pi / 180) is to convert from degree to radians
                          // as the `angel` property is calculated in radians
                          // * Qibla Needle
                          Transform.rotate(
                            angle:
                                (qiblaDirection - _direction) * (math.pi / 180),
                            child: Image.asset(ImageAssets.qibla),
                          ),

                          // * Compass
                          Transform.rotate(
                            angle: -_direction * (math.pi / 180),
                            child: Image.asset(ImageAssets.compass),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const LoadingWidget(),
          error: (errorMsg) => CustomErrorWidget(errorMsg: errorMsg),
        );
      }),
    );
  }
}
