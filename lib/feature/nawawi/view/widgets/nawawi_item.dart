import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/boxes.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/feature/nawawi/logic/models/nawawi.dart';
import 'package:great_quran/feature/nawawi/view/widgets/nawawi_dialog.dart';

class NawawiItem extends StatelessWidget {
  final Nawawi nawawi;
  const NawawiItem({
    super.key,
    required this.nawawi,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: D.sizeLarge,
      ),
      child: Column(
        children: [
          Text(
            nawawi.title,
            style: context.textTheme.displayLarge,
          ),
          B.verticalSizedBoxXSmall,
          Expanded(
            flex: 8,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: D.sizeXXSmall,
                ),
                borderRadius: BorderRadius.circular(D.sizeSmall),
              ),
              padding: const EdgeInsets.all(D.sizeSmall),
              child: SelectableText(
                nawawi.hadith,
                style: context.textTheme.displayLarge,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: D.sizeSmall,
                vertical: D.size3XLarge,
              ),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(D.sizeLarge),
                ),
                onPressed: () => showNawawiDialog(
                  context,
                  nawawi.description,
                ),
                minWidth: double.infinity,
                color: context.colorScheme.secondary,
                child: Text(
                  context.l10n.titleExplanationTheHadith,
                  style: context.textTheme.displayLarge!.copyWith(
                    color: context.colorScheme.surface,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
