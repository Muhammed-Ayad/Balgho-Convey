import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:great_quran/core/assets/assets_manager.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/helpers/ui_helpers.dart';
import 'package:great_quran/core/routes/routes_manager.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/core/widgets/bottom_animation.dart';
import 'package:great_quran/core/widgets/custom_app_bar.dart';
import 'package:great_quran/core/widgets/loading_widget.dart';
import 'package:great_quran/feature/azkar/logic/data/all_azkar.dart';
import 'package:great_quran/feature/azkar/logic/providers/notifications_subscription_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AzkarScreen extends ConsumerStatefulWidget {
  const AzkarScreen({super.key});

  @override
  ConsumerState<AzkarScreen> createState() => _AzkarScreenState();
}

class _AzkarScreenState extends ConsumerState<AzkarScreen> {
  @override
  void initState() {
    super.initState();
    UiHelper.postBuild((_) async {
      await ref
          .read(NotificationsSubscriptionNotifier.provider.notifier)
          .fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: context.l10n.titleAzkar,
        actions: [
          Consumer(builder: (context, ref, _) {
            final state = ref.watch(NotificationsSubscriptionNotifier.provider);
            final notifier =
                ref.read(NotificationsSubscriptionNotifier.provider.notifier);
            return state.when(
              data: (isActive) {
                return IconButton(
                  onPressed: () async {
                    await notifier.toggle();
                  },
                  icon: Icon(
                    isActive ? Icons.notifications : Icons.notification_add,
                    color: isActive ? Colors.amberAccent : null,
                  ),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(D.sizeSmall),
                child: LoadingWidget(
                  size: D.size3XLarge,
                ),
              ),
              error: (err, stack) => IconButton(
                onPressed: () async {
                  await ref
                      .read(NotificationsSubscriptionNotifier.provider.notifier)
                      .fetchData();
                },
                icon: Icon(
                  Icons.refresh,
                  size: D.size3XLarge,
                  color: context.colorScheme.error,
                ),
              ),
            );
          })
        ],
      ),
      body: ListView.builder(
        itemCount: azkarDataList.length,
        itemBuilder: (BuildContext context, int index) {
          return WidgetAnimator(
            child: AzkarItemWidget(index: index),
          );
        },
      ),
    );
  }
}

class AzkarItemWidget extends StatelessWidget {
  final int index;
  const AzkarItemWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.heightR(0.12),
      margin: const EdgeInsets.symmetric(horizontal: D.sizeSmall),
      decoration: BoxDecoration(
        color: context.colorScheme.shadow,
        borderRadius: BorderRadius.circular(D.sizeSmall),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(D.sizeSmall),
        ),
        elevation: D.sizeXSmall,
        child: InkWell(
          onTap: () {
            context.push(
              Routes.azkarCategoryRoute,
              extra: azkarDataList[index].toString().trim(),
            );
          },
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(D.sizeSmall),
                child: Image(
                  fit: BoxFit.fill,
                  image: AssetImage(
                    ImageAssets.star,
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: D.sizeXSmall),
                  child: Text(
                    azkarDataList[index].toString(),
                    style: context.textTheme.headlineLarge,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
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
