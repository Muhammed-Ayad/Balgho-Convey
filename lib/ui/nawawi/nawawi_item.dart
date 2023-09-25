import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:great_quran/blocs/models/nawawi/nawawi.dart';
import 'package:great_quran/generated/locale_keys.g.dart';
import 'package:great_quran/helpers/boxes.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/theme/dimensions.dart';
import 'package:great_quran/ui/widgets/nawawi_dialog.dart';

class NawawiItem extends StatelessWidget {
  final Nawawi nawawi;
  const NawawiItem({
    Key? key,
    required this.nawawi,
  }) : super(key: key);

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
                  LocaleKeys.title_explanation_the_hadith.tr(),
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
