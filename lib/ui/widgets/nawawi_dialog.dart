import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:great_quran/generated/locale_keys.g.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/theme/colors.dart';
import 'package:great_quran/theme/dimensions.dart';

class _NawawiDialog extends StatelessWidget {
  const _NawawiDialog({required this.description});
  final String description;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(D.sizeLarge),
      ),
      content: SelectableText(
        description,
        style: context.textTheme.headlineSmall,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            LocaleKeys.title_close.tr(),
            style:
                context.textTheme.titleSmall!.copyWith(color: AppColors.blue),
          ),
        ),
      ],
    );
  }
}

void showNawawiDialog(BuildContext context, String description) => showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => _NawawiDialog(description: description),
    );
