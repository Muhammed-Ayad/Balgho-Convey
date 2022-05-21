import 'package:flutter/material.dart';
import '../resources/assets_manager.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../app/constants.dart';
import '../resources/color_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';
import '../widgets/appbar_widget.dart';

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
            color: ColorManager.white,
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
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                  const Spacer(),
                  Flexible(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        socialButtons(
                          color: ColorManager.red,
                          icon: Icons.mail_outline_outlined,
                          function: _mailTo,
                        ),
                        socialButtons(
                          color: ColorManager.green,
                          icon: Icons.call_outlined,
                          function: _callPhoneNumber,
                        ),
                        socialButtons(
                          color: ColorManager.blue,
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
    var url = Constants.mailTo;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw Constants.canLaunchError;
    }
  }

  void _callPhoneNumber() async {
    var phoneUrl = Constants.callPhoneNumber;
    if (await canLaunch(phoneUrl)) {
      launch(phoneUrl);
    } else {
      throw Constants.canLaunchError;
    }
  }

  void _facebook() async {
    var phoneUrl = Constants.urlFacebook;
    if (await canLaunch(phoneUrl)) {
      launch(phoneUrl);
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
      radius: AppSize.s24,
      child: CircleAvatar(
        radius: AppSize.s22,
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
