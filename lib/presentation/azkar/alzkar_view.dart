import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';
import '../../animation/bottom_animation.dart';
import '../../data/models/azkar/all_azkar.dart';
import '../widgets/appbar_widget.dart';
import 'azkar_item.dart';

class AzkarView extends StatelessWidget {
  const AzkarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        AppStrings.azkar,
        Constants.elevationAppBarOne,
        context,
      ),
      body: ListView.builder(
        itemCount: azkarDataList.length,
        itemBuilder: (BuildContext context, int index) {
          return WidgetAnimator(child: _buildListItem(context, index));
        },
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    return Container(
      height: AppSize.s70,
      decoration: BoxDecoration(
        color: ColorManager.greyShade200,
        borderRadius: BorderRadius.circular(AppSize.s10),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s10),
        ),
        elevation: AppSize.s5,
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
                padding: EdgeInsets.all(AppPadding.p8),
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
                    horizontal: AppPadding.p4,
                    vertical: AppPadding.p12,
                  ),
                  child: Text(
                    azkarDataList[index].toString(),
                    style: Theme.of(context).textTheme.headlineLarge,
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
