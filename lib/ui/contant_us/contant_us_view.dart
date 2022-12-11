import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:great_quran/generated/locale_keys.g.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/helpers/utilities.dart';
import 'package:great_quran/theme/colors.dart';
import 'package:great_quran/theme/dimensions.dart';
import 'package:great_quran/resources/assets_manager.dart';
import 'package:great_quran/ui/widgets/custom_app_bar.dart';

class ContantUsView extends StatelessWidget {
  const ContantUsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocaleKeys.title_hello.tr(),
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
                    LocaleKeys.title_contant_us.tr(),
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
