import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

import 'dart:math' as math;

import 'package:great_quran/helpers/constants.dart';
import 'package:great_quran/theme/dimensions.dart';
import 'package:great_quran/resources/assets_manager.dart';
import 'package:great_quran/resources/strings_manager.dart';
import 'package:great_quran/ui/widgets/appbar_widget.dart';

class KibleScreen extends StatefulWidget {
  const KibleScreen({Key? key}) : super(key: key);

  @override
  _KibleScreenState createState() => _KibleScreenState();
}

class _KibleScreenState extends State<KibleScreen> {
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
      appBar: appBarWidget(
        AppStrings.kible,
        Constants.elevationAppBarOne,
        context,
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
