import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

import 'dart:math' as math;

import 'package:great_quran/theme/dimensions.dart';
import 'package:great_quran/resources/assets_manager.dart';
import 'package:great_quran/resources/strings_manager.dart';
import 'package:great_quran/ui/widgets/custom_app_bar.dart';

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

  void _getDirection() {
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
        title: AppStrings.kible,
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
                    // *Kiblat
                    Transform.rotate(
                      angle: ((_direction != 0 ? _direction + 65 : 0) *
                          (math.pi / 180) *
                          -1),
                      child: Image.asset(ImageAssets.kiblat),
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
