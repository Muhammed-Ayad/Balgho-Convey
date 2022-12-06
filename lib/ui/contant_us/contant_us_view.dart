import 'package:flutter/material.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/helpers/utilities.dart';
import 'package:great_quran/theme/colors.dart';
import 'package:great_quran/theme/dimensions.dart';
import 'package:great_quran/resources/assets_manager.dart';
import 'package:great_quran/resources/strings_manager.dart';
import 'package:great_quran/ui/widgets/custom_app_bar.dart';

class ContantUsView extends StatelessWidget {
  const ContantUsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: AppStrings.hello,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          image: const DecorationImage(
            image: AssetImage(ImageAssets.contact),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  flex: 3,
                  child: Text(
                    AppStrings.contantUs,
                    style: context.textTheme.displayLarge,
                  ),
                ),
                const Spacer(),
                Flexible(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.red,
                        radius: D.sizeXXLarge,
                        child: CircleAvatar(
                          radius: D.sizeXLarge,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: Icon(
                              Icons.mail_outline_outlined,
                              color: AppColors.red,
                            ),
                            onPressed: Utilities.sendMessage,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
