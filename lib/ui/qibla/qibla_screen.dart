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
    _getDirection();
  }

  void _getDirection() async {
    FlutterCompass.events!.listen((direction) {
      if (mounted) {
        setState(() => _direction = 0);
      }
      _direction = direction.heading!;
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
          data: (data) {
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
                          // * Qibla
                          Transform.rotate(
                            angle: ((_direction != 0 ? _direction + data : 0) *
                                (math.pi / 180) *
                                -1),
                            child: Image.asset(ImageAssets.qibla),
                          ),

                          // * Compass
                          Transform.rotate(
                            angle: ((_direction != 0 ? _direction : 0) *
                                (math.pi / 180) *
                                -1),
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


// class QiblaCompassWidget extends StatelessWidget {
//   final _compassImage = Image.asset(ImageAssets.compass);
//   final _needleImage = Image.asset(
//     ImageAssets.qibla,
//     fit: BoxFit.contain,
//     height: 300,
//     alignment: Alignment.center,
//   );

//   QiblaCompassWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FlutterQiblah.qiblahStream,
//       builder: (_, AsyncSnapshot<QiblahDirection> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const LoadingIndicator(
//             indicatorType: Indicator.ballPulse,
//           );
//         }

//         final qiblaDirection = snapshot.data;

//         return Stack(
//           alignment: Alignment.center,
//           children: <Widget>[
//             Transform.rotate(
//               angle: ((qiblaDirection?.qiblah ?? 0) * (math.pi / 180) * -1),
//               alignment: Alignment.center,
//               child: _needleImage,
//             ),
//             Transform.rotate(
//               angle: ((qiblaDirection?.direction ?? 0) * (math.pi / 180) * -1),
//               child: _compassImage,
//             ),
//             Positioned(
//               bottom: 8,
//               child: Text("${qiblaDirection?.offset.toStringAsFixed(3)}°"),
//             )
//           ],
//         );
//       },
//     );
//   }
// }
