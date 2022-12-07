import 'package:flutter/material.dart';
import 'package:great_quran/blocs/models/nawawi/nawawi.dart';
import 'package:great_quran/helpers/boxes.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/theme/colors.dart';
import 'package:great_quran/theme/dimensions.dart';
import 'package:great_quran/resources/strings_manager.dart';
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
                child: Text(
                  AppStrings.explanationOfTheHadith,
                  style: context.textTheme.displayLarge!
                      .copyWith(color: AppColors.white),
                ),
                color: AppColors.brownShade300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
