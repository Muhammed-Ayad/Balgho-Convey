import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:great_quran/generated/locale_keys.g.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/theme/colors.dart';
import 'package:great_quran/ui/widgets/custom_app_bar.dart';

class ErrorWidgetApp extends StatelessWidget {
  const ErrorWidgetApp({super.key, this.errorMsg});
  final String? errorMsg;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: LocaleKeys.error_error.tr()),
      body: Center(
        child: Text(
          errorMsg ?? LocaleKeys.error_error.tr(),
          style: context.textTheme.displayLarge!.copyWith(color: AppColors.red),
        ),
      ),
    );
  }
}
