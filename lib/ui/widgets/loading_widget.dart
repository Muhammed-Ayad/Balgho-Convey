import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/theme/colors.dart';

class LoadingWidget extends StatelessWidget {
  final double? size;
  const LoadingWidget({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitCircle(
        color: AppColors.primary,
        size: size ?? context.heightR(0.1),
      ),
    );
  }
}
