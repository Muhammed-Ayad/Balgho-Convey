import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppLottieWidget extends StatelessWidget {
  final String assetPath;
  final double width;
  final double height;
  final Widget? fallback;
  final bool repeat;

  const AppLottieWidget({
    super.key,
    required this.assetPath,
    this.width = 120,
    this.height = 120,
    this.fallback,
    this.repeat = true,
  });

  const AppLottieWidget.loading({
    super.key,
    this.width = 100,
    this.height = 100,
    this.fallback,
    this.repeat = true,
  }) : assetPath = 'assets/json/loading_animation.json';

  const AppLottieWidget.error({
    super.key,
    this.width = 110,
    this.height = 110,
    this.fallback,
    this.repeat = true,
  }) : assetPath = 'assets/json/error_animation.json';

  const AppLottieWidget.empty({
    super.key,
    this.width = 110,
    this.height = 110,
    this.fallback,
    this.repeat = true,
  }) : assetPath = 'assets/json/empty_animation.json';

  const AppLottieWidget.success({
    super.key,
    this.width = 100,
    this.height = 100,
    this.fallback,
    this.repeat = false,
  }) : assetPath = 'assets/json/success_animation.json';

  @override
  Widget build(BuildContext context) {
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return fallback ??
          SizedBox(
            width: width,
            height: height,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
          );
    }

    return Lottie.asset(
      assetPath,
      width: width,
      height: height,
      repeat: repeat,
      errorBuilder: (context, error, stackTrace) {
        return fallback ??
            SizedBox(
              width: width,
              height: height,
              child: const Icon(Icons.refresh_rounded, size: 36),
            );
      },
    );
  }
}
