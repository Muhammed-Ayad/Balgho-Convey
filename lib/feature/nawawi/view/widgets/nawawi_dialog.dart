import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';

class NawawiDialog extends StatelessWidget {
  const NawawiDialog({super.key, required this.description});
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
            context.l10n.titleClose,
            style: context.textTheme.titleSmall!.copyWith(
              color: context.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}

void showNawawiDialog(BuildContext context, String description) => showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => NawawiDialog(description: description),
    );
