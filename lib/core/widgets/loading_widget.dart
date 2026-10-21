import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/widgets/app_lottie_widget.dart';

class LoadingWidget extends StatelessWidget {
  final double? size;
  final String? message;

  const LoadingWidget({super.key, this.size, this.message});

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppLottieWidget.loading(
            width: size ?? 100,
            height: size ?? 100,
            fallback: SizedBox(
              width: size ?? 48,
              height: size ?? 48,
              child: CircularProgressIndicator(
                color: primary,
                strokeWidth: 3,
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(
              message!,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
