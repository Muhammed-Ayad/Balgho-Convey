import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import '../../helpers/constants.dart';
import '../resources/assets_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';
import 'dart:math' as math;

import '../widgets/appbar_widget.dart';

class KibleView extends StatefulWidget {
  const KibleView({Key? key}) : super(key: key);

  @override
  _KibleViewState createState() => _KibleViewState();
}

class _KibleViewState extends State<KibleView> {
  double _direction = AppSize.s0;

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
        setState(() => _direction = AppSize.s0);
      }
      _direction = direction.heading!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          appBarWidget(AppStrings.kible, Constants.elevationAppBarOne, context),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSize.s20),
                child: Stack(
                  children: [
                    // *Kiblat
                    Transform.rotate(
                      angle: ((_direction != AppSize.s0
                              ? _direction + AppSize.s65
                              : AppSize.s0) *
                          (math.pi / AppSize.s180) *
                          -1),
                      child: Image.asset(ImageAssets.kiblat),
                    ),

                    // * Compass
                    Transform.rotate(
                      angle: ((_direction != AppSize.s0
                              ? _direction
                              : AppSize.s0) *
                          (math.pi / AppSize.s180) *
                          -1),
                      child: Image.asset(ImageAssets.kompas),
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
