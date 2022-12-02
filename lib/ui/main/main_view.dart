import 'package:flutter/material.dart';
import '../../helpers/constants.dart';
import '../resources/assets_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';
import '../widgets/appbar_widget.dart';
import '../drawer/drawer_page.dart';

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
          AppStrings.titleAppNote, Constants.elevationAppBarOne, context),
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
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.s8,
            vertical: AppSize.s8,
          ),
          child: Column(
            children: [
              Expanded(
                flex: 8,
                child: Card(
                  elevation: AppSize.s10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.s10),
                  ),
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.s10),
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
                  elevation: AppSize.s10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.s10),
                  ),
                  child: Center(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge,
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
