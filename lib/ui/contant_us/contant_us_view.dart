import 'package:flutter/material.dart';
import 'package:great_quran/data/remote/endpoints.dart';
import 'package:great_quran/helpers/constants.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/theme/colors.dart';
import 'package:great_quran/theme/dimensions.dart';
import 'package:great_quran/resources/assets_manager.dart';
import 'package:great_quran/resources/strings_manager.dart';
import 'package:great_quran/ui/widgets/appbar_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ContantUsView extends StatelessWidget {
  const ContantUsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWidget(
          AppStrings.hello,
          Constants.elevationAppBarOne,
          context,
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
                        socialButtons(
                          color: AppColors.red,
                          icon: Icons.mail_outline_outlined,
                          function: _mailTo,
                        ),
                        socialButtons(
                          color: AppColors.green,
                          icon: Icons.call_outlined,
                          function: _callPhoneNumber,
                        ),
                        socialButtons(
                          color: AppColors.blue,
                          icon: Icons.facebook,
                          function: _facebook,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  void _mailTo() async {
    final uri = Uri(path: AppEndpoints.mailTo);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw Constants.canLaunchError;
    }
  }

  void _callPhoneNumber() async {
    final uri = Uri(path: AppEndpoints.callPhoneNumber);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri);
    } else {
      throw Constants.canLaunchError;
    }
  }

  void _facebook() async {
    final uri = Uri(path: AppEndpoints.urlFacebook);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri);
    } else {
      throw Constants.canLaunchError;
    }
  }

  Widget socialButtons(
      {required Color color,
      required IconData icon,
      required Function function}) {
    return CircleAvatar(
      backgroundColor: color,
      radius: D.sizeXXLarge,
      child: CircleAvatar(
        radius: D.sizeXLarge,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: Icon(
            icon,
            color: color,
          ),
          onPressed: () {
            function();
          },
        ),
      ),
    );
  }
}
