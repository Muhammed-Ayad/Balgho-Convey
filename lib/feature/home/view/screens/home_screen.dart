import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:great_quran/core/assets/assets_manager.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/routes/routes_manager.dart';
import 'package:great_quran/core/widgets/card_view.dart';
import 'package:great_quran/core/widgets/custom_app_bar.dart';
import 'package:great_quran/core/widgets/grid_tile_widget.dart';
import 'package:great_quran/feature/azkar/logic/providers/notifications_subscription_notifier.dart';
import 'package:great_quran/feature/home/view/widgets/drawer_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    ref
        .read(NotificationsSubscriptionNotifier.provider.notifier)
        .navigateOnNotificationLaunch(
          (category) =>
              context.push(Routes.azkarCategoryRoute, extra: category),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: context.l10n.titleAppBar,
        ),
        drawer: const DrawerWidget(),
        body: StaggeredGrid.count(
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          axisDirection: AxisDirection.down,
          children: [
            GridTileWidget(
              child: CardViewWidget(
                context.l10n.titleRadio,
                Routes.radiosRoute,
                ImageAssets.radio,
              ),
            ),
            GridTileWidget(
              child: CardViewWidget(
                context.l10n.titleAzkar,
                Routes.azkarRoute,
                ImageAssets.azkar,
              ),
            ),
            GridTileWidget(
              child: CardViewWidget(
                context.l10n.titleAzan,
                Routes.azanRoute,
                ImageAssets.prayer,
              ),
            ),
            GridTileWidget(
              child: CardViewWidget(
                context.l10n.titleQibla,
                Routes.qiblaRoute,
                ImageAssets.kabaa,
              ),
            ),
            GridTileWidget(
              isLast: true,
              child: CardViewWidget(
                context.l10n.titleNawawi,
                Routes.nawawiRoute,
                ImageAssets.nawawi,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
