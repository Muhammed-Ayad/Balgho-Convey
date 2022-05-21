import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../resources/color_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/values_manager.dart';
import 'package:share_plus/share_plus.dart';
import 'package:in_app_review/in_app_review.dart';
import '../resources/strings_manager.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final InAppReview inAppReview = InAppReview.instance;

    return SafeArea(
      child: Drawer(
        child: ListView(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSize.s10,
                vertical: AppSize.s16,
              ),
              title: Align(
                alignment: Alignment.center,
                child: Text(
                  AppStrings.titleAppNote,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
            ),
            Divider(
              color: ColorManager.black38,
            ),
            builderListTile(
              context: context,
              onTap: () {
                Navigator.pushNamed(context, Routes.contantUsRoute);
              },
              title: AppStrings.contantUs,
              icon: Icons.contact_support,
            ),
            builderListTile(
              context: context,
              onTap: () {
                Share.share(Constants.linkPlayGoogle);
              },
              title: AppStrings.share,
              icon: Icons.share,
            ),
            builderListTile(
              context: context,
              onTap: () async {
                if (await inAppReview.isAvailable()) {
                  inAppReview.requestReview();
                }
                inAppReview.openStoreListing();
              },
              title: AppStrings.review,
              icon: Icons.reviews,
            ),
          ],
        ),
      ),
    );
  }

  Widget builderListTile(
      {required BuildContext context,
      required VoidCallback onTap,
      required String title,
      required IconData icon}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSize.s12),
        child: Card(
          elevation: AppSize.s1_5,
          color: ColorManager.greyShade200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppSize.s20,
            ),
          ),
          child: ListTile(
            title: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Icon(
                    icon,
                    color: ColorManager.blue,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
