import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:great_quran/generated/locale_keys.g.dart';
import 'package:great_quran/helpers/extensions.dart';
 import 'package:great_quran/theme/dimensions.dart';
import 'package:great_quran/ui/widgets/custom_app_bar.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    Key? key,
    this.errorMsg,
    this.onRefresh,
  }) : super(key: key);

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
              "${LocaleKeys.error_error.tr()}${errorMsg != null ? ': $errorMsg' : ''}",
              textAlign: TextAlign.center,
              style: context.textTheme.displayLarge
                  ?.copyWith(color: context.colorScheme.error,),
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

class ErrorWidgetApp extends StatelessWidget {
  const ErrorWidgetApp({super.key, this.errorMsg});
  final String? errorMsg;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: LocaleKeys.error_error.tr()),
      body: CustomErrorWidget(errorMsg: errorMsg),
    );
  }
}
