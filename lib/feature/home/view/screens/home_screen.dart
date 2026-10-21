import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/helpers/ui_helpers.dart';
import 'package:great_quran/core/routes/routes_manager.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/core/widgets/custom_app_bar.dart';
import 'package:great_quran/feature/azan/logic/providers/azan_provider.dart';
import 'package:great_quran/feature/azkar/logic/providers/notifications_subscription_notifier.dart';
import 'package:great_quran/feature/daily_zekr/view/widgets/daily_zekr_card.dart';
import 'package:great_quran/feature/home/view/widgets/feature_grid_card.dart';
import 'package:great_quran/feature/home/view/widgets/morning_evening_azkar_card.dart';
import 'package:great_quran/feature/home/view/widgets/next_prayer_card.dart';
import 'package:great_quran/feature/home/view/widgets/section_header.dart';
import 'package:great_quran/feature/radios/view/widgets/radio_mini_player_widget.dart';
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

    UiHelper.postBuild((_) {
      ref.read(AzanTimeNotifier.provider.notifier).getAzan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: context.l10n.titleAppBar,
        actions: [
          IconButton(
            icon: const Icon(Icons.star_rounded, color: Colors.amber),
            tooltip: "المفضلة",
            onPressed: () {
              context.push(Routes.favoritesRoute);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: "الإعدادات",
            onPressed: () {
              context.push(Routes.settingsRoute);
            },
          ),
        ],
      ),
      bottomNavigationBar: const RadioMiniPlayerWidget(),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: D.sizeSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NextPrayerCard(),
              DailyZekrCard(),
              SizedBox(height: D.sizeSmall),
              HomeSectionHeaderWidget(
                title: "أذكار اليوم والليلة",
                icon: Icons.wb_twilight_rounded,
              ),
              MorningEveningAzkarSectionWidget(),
              SizedBox(height: D.sizeMedium),
              HomeSectionHeaderWidget(
                title: "الخدمات الإسلامية",
                icon: Icons.grid_view_rounded,
              ),
              MainFeaturesGridWidget(),
              SizedBox(height: D.sizeXXLarge),
            ],
          ),
        ),
      ),
    );
  }
}
