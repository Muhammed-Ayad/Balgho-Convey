import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/generated/locale_keys.g.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/theme/dimensions.dart';
import 'package:great_quran/ui/drawer/drawer_page.dart';
import 'package:great_quran/resources/assets_manager.dart';
import 'package:great_quran/resources/routes_manager.dart';
import 'package:great_quran/ui/widgets/custom_app_bar.dart';

import '../data/local/json/all_azkar.dart';
import '../helpers/enums.dart';
import '../services/local_notification_service.dart';
import 'azkar/azkar_category_screen.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  ConsumerState<MainView> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  @override
  void initState() {
    super.initState();
    _checkAppLaunchNotification();
  }

  Future<void> _checkAppLaunchNotification() async {
    final notificationService = ref.read(LocalNotificationService.provider);

    final notificationLaunch = await notificationService
        .flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();

    if (notificationLaunch?.didNotificationLaunchApp ?? false) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AzkarCategoryScreen(
            azkar: azkarDataList[AzkarType.fromName(
                            notificationLaunch?.notificationResponse?.payload)
                        ?.index ??
                    0]
                .toString()
                .trim(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: LocaleKeys.title_app_bar.tr(),
        ),
        drawer: const DrawerPage(),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  buildCard(
                    LocaleKeys.title_radio.tr(),
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
                    LocaleKeys.title_azkar.tr(),
                    Routes.azkarRoute,
                    ImageAssets.azkar,
                    context,
                  ),
                  buildCard(
                    LocaleKeys.title_azan.tr(),
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
                    LocaleKeys.title_kible.tr(),
                    Routes.qiblaRoute,
                    ImageAssets.qubla,
                    context,
                  ),
                  buildCard(
                    LocaleKeys.title_nawawi.tr(),
                    Routes.nawawiRoute,
                    ImageAssets.nawawi,
                    context,
                  ),
                ],
              ),
            ),
          ],
        ),
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
