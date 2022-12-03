import 'package:flutter/material.dart';
import 'package:great_quran/helpers/constants.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/theme/dimensions.dart';
import 'package:great_quran/ui/drawer/drawer_page.dart';
import 'package:great_quran/resources/assets_manager.dart';
import 'package:great_quran/resources/routes_manager.dart';
import 'package:great_quran/resources/strings_manager.dart';
import 'package:great_quran/ui/widgets/appbar_widget.dart';

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        AppStrings.titleAppNote,
        Constants.elevationAppBarOne,
        context,
      ),
      drawer: const DrawerPage(),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                buildCard(
                  AppStrings.quran,
                  Routes.quranRoute,
                  ImageAssets.quran,
                  context,
                ),
                buildCard(
                  AppStrings.radio,
                  Routes.radiosRoute,
                  ImageAssets.radio,
                  context,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                buildCard(
                  AppStrings.azkar,
                  Routes.azkarRoute,
                  ImageAssets.azkar,
                  context,
                ),
                buildCard(
                  AppStrings.azan,
                  Routes.azanRoute,
                  ImageAssets.azan,
                  context,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                buildCard(
                  AppStrings.kible,
                  Routes.kibleRoute,
                  ImageAssets.qubla,
                  context,
                ),
                buildCard(
                  AppStrings.nawawi,
                  Routes.nawawiRoute,
                  ImageAssets.nawawi,
                  context,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard(
      String title, String route, String image, BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        child: Padding(
          padding: const EdgeInsets.all(
            D.sizeSmall,
          ),
          child: Column(
            children: [
              Expanded(
                flex: 8,
                child: Card(
                  elevation: D.sizeSmall,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      D.sizeSmall,
                    ),
                  ),
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        D.sizeSmall,
                      ),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(image),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Card(
                  elevation: D.sizeSmall,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      D.sizeSmall,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      title,
                      style: context.textTheme.bodyLarge,
                    ),
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
