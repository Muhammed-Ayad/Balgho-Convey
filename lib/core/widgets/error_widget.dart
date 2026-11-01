import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/core/widgets/app_lottie_widget.dart';

class CustomErrorWidget extends StatelessWidget {
  final String? errorMsg;
  final VoidCallback? onRefresh;

  const CustomErrorWidget({
    super.key,
    this.errorMsg,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(D.sizeLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppLottieWidget.error(
              width: 100,
              height: 100,
              fallback: Icon(
                Icons.error_outline_rounded,
                size: 54,
                color: context.colorScheme.error,
              ),
            ),
            const SizedBox(height: D.sizeSmall),
            Text(
              "حدث خطأ أثناء تحميل البيانات",
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (errorMsg != null && errorMsg!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                errorMsg!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (onRefresh != null) ...[
              const SizedBox(height: D.sizeMedium),
              ElevatedButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text("إعادة المحاولة"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
