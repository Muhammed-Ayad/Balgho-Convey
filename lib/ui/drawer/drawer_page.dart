import 'package:flutter/material.dart';
import 'package:great_quran/data/remote/endpoints.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/theme/colors.dart';
import 'package:great_quran/theme/dimensions.dart';
import 'package:great_quran/resources/routes_manager.dart';
import 'package:great_quran/resources/strings_manager.dart';

import 'package:share_plus/share_plus.dart';
import 'package:in_app_review/in_app_review.dart';

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
                horizontal: D.sizeSmall,
                vertical: D.sizeLarge,
              ),
              title: Align(
                alignment: Alignment.center,
                child: Text(
                  AppStrings.titleAppNote,
                  style: context.textTheme.displayLarge,
                ),
              ),
            ),
            Divider(
              color: AppColors.black38,
            ),
            builderListTile(
              context: context,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.contantUsRoute,
                );
              },
              title: AppStrings.contantUs,
              icon: Icons.contact_support,
            ),
            builderListTile(
              context: context,
              onTap: () {
                Share.share(AppEndpoints.linkPlayGoogle);
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
        padding: const EdgeInsets.all(
          D.sizeMedium,
        ),
        child: Card(
          elevation: D.sizeXXSmall,
          color: AppColors.greyShade200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              D.sizeXLarge,
            ),
          ),
          child: ListTile(
            title: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    title,
                    style: context.textTheme.headlineLarge,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Icon(
                    icon,
                    color: AppColors.blue,
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
