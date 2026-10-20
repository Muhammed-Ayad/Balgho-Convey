import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    super.key,
    this.errorMsg,
    this.onRefresh,
  });

  final String? errorMsg;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(D.sizeLarge),
          child: Center(
            child: Text(
              "${context.l10n.errorError}${errorMsg != null ? ': $errorMsg' : ''}",
              textAlign: TextAlign.center,
              style: context.textTheme.displayLarge
                  ?.copyWith(color: context.colorScheme.error),
            ),
          ),
        ),
        if (onRefresh != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: D.sizeSmall),
            child: IconButton(
                onPressed: onRefresh,
                icon: Icon(
                  Icons.refresh,
                  size: D.size3XLarge,
                  color: context.colorScheme.error,
                )),
          )
      ],
    );
  }
}
