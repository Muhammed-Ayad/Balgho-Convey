import 'package:flutter/material.dart';
import '../../helpers/constants.dart';
import '../resources/color_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';
import '../widgets/appbar_widget.dart';

class NawawiItem extends StatelessWidget {
  final String hadith;
  final String description;
  final String title;

  const NawawiItem(
      {Key? key,
      required this.hadith,
      required this.description,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(title, Constants.elevationAppBarZero, context),
      body: Column(
        children: [
          const SizedBox(height: AppSize.s20),
          Expanded(
            flex: 8,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: AppSize.s1,
                ),
                borderRadius: BorderRadius.circular(AppSize.s10),
              ),
              padding: const EdgeInsets.all(AppSize.s10),
              child: SelectableText(
                hadith,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSize.s10,
                vertical: AppSize.s30,
              ),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.s16),
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
                            borderRadius: BorderRadius.circular(AppSize.s16),
                          ),
                          content: SelectableText(
                            description,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                AppStrings.close,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(color: ColorManager.blue),
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
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(color: ColorManager.white),
                ),
                color: ColorManager.brownShade300,
              ),
            ),
          ),
          const SizedBox(height: AppSize.s20),
        ],
      ),
    );
  }
}
