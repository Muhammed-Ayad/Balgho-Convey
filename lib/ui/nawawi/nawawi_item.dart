import 'package:flutter/material.dart';
import 'package:great_quran/blocs/models/nawawi/nawawi.dart';
import 'package:great_quran/helpers/boxes.dart';
import 'package:great_quran/helpers/constants.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/theme/colors.dart';
import 'package:great_quran/theme/dimensions.dart';
import 'package:great_quran/resources/strings_manager.dart';
import 'package:great_quran/ui/widgets/appbar_widget.dart';

class NawawiItem extends StatelessWidget {
  final Nawawi nawawi;

  const NawawiItem({
    Key? key,
    required this.nawawi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        nawawi.title,
        Constants.elevationAppBarZero,
        context,
      ),
      body: Column(
        children: [
          const SizedBox(height: D.sizeXLarge),
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
                onPressed: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      // ignore: avoid_unnecessary_containers
                      return Container(
                        child: AlertDialog(
                          scrollable: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(D.sizeLarge),
                          ),
                          content: SelectableText(
                            nawawi.description,
                            style: context.textTheme.headlineSmall,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                AppStrings.close,
                                style: context.textTheme.titleSmall!
                                    .copyWith(color: AppColors.blue),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
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
          B.verticalSizedBoxXLarge,
        ],
      ),
    );
  }
}
