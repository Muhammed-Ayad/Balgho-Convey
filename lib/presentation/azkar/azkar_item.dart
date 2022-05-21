import 'package:flutter/material.dart';
import '../resources/strings_manager.dart';
import 'package:share_plus/share_plus.dart';
import '../../app/constants.dart';
import '../../data/models/azkar/azkar_by_category.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/values_manager.dart';
import '../widgets/appbar_widget.dart';
import 'package:clipboard/clipboard.dart';

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
                  padding: const EdgeInsets.all(AppPadding.p8),
                  child: Container(
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                          opacity: 0.6,
                          fit: BoxFit.fill,
                          image: AssetImage(
                            ImageAssets.test1,
                          )),
                      borderRadius: BorderRadius.circular(AppSize.s10),
                      border: Border.all(
                        color: ColorManager.greyShade500,
                        width: AppSize.s1,
                      ),
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(AppPadding.p8),
                      child: SelectableText(
                        azkar.zekr,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppPadding.p8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorManager.greyShade200,
                      borderRadius: BorderRadius.circular(AppSize.s10),
                      border: Border.all(
                        color: ColorManager.greyShade500,
                        width: AppSize.s1,
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
                            color: ColorManager.blue,
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
                                  backgroundColor: ColorManager.grey2,
                                  content: Text(
                                    AppStrings.copy,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(color: ColorManager.white),
                                  ),
                                ),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.copy,
                            color: ColorManager.blue,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          azkar.count,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                fontSize: AppSize.s26,
                              ),
                        ),
                        const SizedBox(
                          width: AppSize.s5,
                        ),
                        Icon(
                          Icons.repeat,
                          color: ColorManager.blue,
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
