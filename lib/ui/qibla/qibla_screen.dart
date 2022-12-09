import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:great_quran/blocs/state_mix/_index.dart';

import 'dart:math' as math;

import 'package:great_quran/theme/dimensions.dart';
import 'package:great_quran/resources/assets_manager.dart';
import 'package:great_quran/resources/strings_manager.dart';
import 'package:great_quran/ui/widgets/custom_app_bar.dart';
import 'package:loading_indicator/loading_indicator.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({Key? key}) : super(key: key);

  @override
  _QiblaScreenState createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  double _direction = 0;

  @override
  void initState() {
    super.initState();

    _getDirection();
  }

  @override
  void dispose() {
    _direction;
    super.dispose();
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
      body: Column(
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
                      angle: ((_direction != 0 ? _direction + 65 : 0) *
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
      ),
    );
  }
}

class QiblaCompassWidget extends StatelessWidget {
  final _compassImage = Image.asset(ImageAssets.compass);
  final _needleImage = Image.asset(
    ImageAssets.qibla,
    fit: BoxFit.contain,
    height: 300,
    alignment: Alignment.center,
  );

  QiblaCompassWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FlutterQiblah.qiblahStream,
      builder: (_, AsyncSnapshot<QiblahDirection> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingIndicator(
            indicatorType: Indicator.ballPulse,
          );
        }

        final qiblaDirection = snapshot.data;

        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Transform.rotate(
              angle: ((qiblaDirection?.qiblah ?? 0) * (math.pi / 180) * -1),
              alignment: Alignment.center,
              child: _needleImage,
            ),
            Transform.rotate(
              angle: ((qiblaDirection?.direction ?? 0) * (math.pi / 180) * -1),
              child: _compassImage,
            ),
            Positioned(
              bottom: 8,
              child: Text("${qiblaDirection?.offset.toStringAsFixed(3)}°"),
            )
          ],
        );
      },
    );
  }
}
