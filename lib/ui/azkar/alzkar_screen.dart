import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:great_quran/data/local/json/all_azkar.dart';
import 'package:great_quran/generated/locale_keys.g.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/theme/colors.dart';
import 'package:great_quran/theme/dimensions.dart';
import 'package:great_quran/ui/animations/bottom_animation.dart';
import 'package:great_quran/resources/assets_manager.dart';
import 'package:great_quran/ui/widgets/custom_app_bar.dart';
import 'azkar_item.dart';

class AzkarScreen extends StatelessWidget {
  const AzkarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocaleKeys.title_azkar.tr(),
      ),
      body: ListView.builder(
        itemCount: azkarDataList.length,
        itemBuilder: (BuildContext context, int index) {
          return WidgetAnimator(
            child: _ItemWidget(index),
          );
        },
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  final int index;
  const _ItemWidget(this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.heightR(0.1),
      decoration: BoxDecoration(
        color: AppColors.greyShade200,
        borderRadius: BorderRadius.circular(D.sizeSmall),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(D.sizeSmall),
        ),
        elevation: D.sizeXSmall,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AzkarItem(
                  azkar: azkarDataList[index].toString().trim(),
                ),
              ),
            );
          },
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(D.sizeSmall),
                child: Image(
                  fit: BoxFit.fill,
                  image: AssetImage(
                    ImageAssets.star,
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: D.sizeXSmall,
                    vertical: D.sizeMedium,
                  ),
                  child: Text(
                    azkarDataList[index].toString(),
                    style: context.textTheme.headlineLarge,
                    softWrap: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
