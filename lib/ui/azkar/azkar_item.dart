import 'package:flutter/material.dart';
import 'package:great_quran/data/local/json/azkar_by_category.dart';
import 'package:clipboard/clipboard.dart';
import 'package:great_quran/helpers/boxes.dart';
import 'package:great_quran/helpers/constants.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/theme/colors.dart';
import 'package:great_quran/theme/dimensions.dart';
import 'package:great_quran/resources/assets_manager.dart';
import 'package:great_quran/resources/strings_manager.dart';
import 'package:great_quran/ui/widgets/appbar_widget.dart';
import 'package:share_plus/share_plus.dart';

class AzkarItem extends StatefulWidget {
  const AzkarItem({Key? key, required this.azkar}) : super(key: key);
  final String azkar;

  @override
  State<AzkarItem> createState() => _AzkarItemState();
}

class _AzkarItemState extends State<AzkarItem> {
  AzkarByCategory azkarByCategory = AzkarByCategory();

  @override
  void initState() {
    azkarByCategory.getAzkarByCategory(widget.azkar);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        widget.azkar,
        Constants.elevationAppBarOne,
        context,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: azkarByCategory.azkarList.map((azkar) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(D.sizeSmall),
                  child: Container(
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        opacity: 0.6,
                        fit: BoxFit.fill,
                        image: AssetImage(
                          ImageAssets.test1,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(D.sizeMedium),
                      border: Border.all(
                        color: AppColors.greyShade500,
                        width: D.sizeXXSmall,
                      ),
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(D.sizeSmall),
                      child: SelectableText(
                        azkar.zekr,
                        style: context.textTheme.headlineMedium!
                            .copyWith(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(D.sizeSmall),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.greyShade200,
                      borderRadius: BorderRadius.circular(
                        D.sizeSmall,
                      ),
                      border: Border.all(
                        color: AppColors.greyShade500,
                        width: D.sizeXXSmall,
                      ),
                    ),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            Share.share(azkar.zekr);
                          },
                          icon: Icon(
                            Icons.share,
                            color: AppColors.blue,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            FlutterClipboard.copy(azkar.zekr).then(
                              (value) =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(
                                      milliseconds: Constants.milliseconds),
                                  backgroundColor: AppColors.grey2,
                                  content: Text(
                                    AppStrings.copy,
                                    style: context.textTheme.headlineSmall!
                                        .copyWith(color: AppColors.white),
                                  ),
                                ),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.copy,
                            color: AppColors.blue,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          azkar.count,
                          style: context.textTheme.headlineSmall!.copyWith(
                            fontSize: D.sizeXXLarge,
                          ),
                        ),
                        B.horizontalSizedBoxXSmall,
                        Icon(
                          Icons.repeat,
                          color: AppColors.blue,
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
