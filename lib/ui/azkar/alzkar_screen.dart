import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/data/local/json/all_azkar.dart';
import 'package:great_quran/generated/locale_keys.g.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/helpers/ui_helpers.dart';
import 'package:great_quran/theme/colors.dart';
import 'package:great_quran/theme/dimensions.dart';
import 'package:great_quran/ui/animations/bottom_animation.dart';
import 'package:great_quran/resources/assets_manager.dart';
import 'package:great_quran/ui/widgets/custom_app_bar.dart';
import '../../helpers/enums.dart';
import '../../services/local_notification_service.dart';
import 'azkar_category_screen.dart';

final _hasRegisteredNotifications = StateProvider<bool>((ref) => false);

class AzkarScreen extends ConsumerStatefulWidget {
  const AzkarScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AzkarScreen> createState() => _AzkarScreenState();
}

class _AzkarScreenState extends ConsumerState<AzkarScreen> {
  late final LocalNotificationService _notificationService;
  @override
  void initState() {
    super.initState();
    _notificationService = ref.read(LocalNotificationService.provider);
    UiHelper.postBuild((_) async {
      ref.read(_hasRegisteredNotifications.notifier).state =
          await _notificationService.checkPendingNotifications();
    });
  }

  Future<void> _registerAzkarNotifications() async {
    final now = DateTime.now();

    await ref.read(LocalNotificationService.provider).schedule(
        scheduleReminder: ScheduleReminder.daily,
        dateTime: DateTime(now.year, now.month, now.day, 7),
        title: "بلغوا",
        body: "نذكرك بقراءة أذكار الصباح",
        payload: AzkarType.morning.name);

    await ref.read(LocalNotificationService.provider).schedule(
        scheduleReminder: ScheduleReminder.daily,
        dateTime: DateTime(now.year, now.month, now.day, 17, 00),
        title: "بلغوا",
        body: "نذكرك بقراءة أذكار المساء",
        payload: AzkarType.evening.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocaleKeys.title_azkar.tr(),
        actions: [
          IconButton(onPressed: () async {
            if (ref.read(_hasRegisteredNotifications)) {
              await _notificationService.cancelAll();
              ref.read(_hasRegisteredNotifications.notifier).state = false;
            } else {
              _registerAzkarNotifications();
              ref.read(_hasRegisteredNotifications.notifier).state = true;
            }
          }, icon: Consumer(builder: (context, ref, _) {
            final isActive = ref.watch(_hasRegisteredNotifications);
            return Icon(
              isActive ? Icons.notifications : Icons.notification_add,
              color: isActive ? Colors.red : null,
            );
          }))
        ],
      ),
      body: ListView.builder(
        itemCount: azkarDataList.length,
        itemBuilder: (BuildContext context, int index) {
          return WidgetAnimator(
            child: _ItemWidget(index),
          );
        },
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  final int index;
  const _ItemWidget(this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.heightR(0.12),
      margin: const EdgeInsets.symmetric(horizontal: D.sizeSmall),
      decoration: BoxDecoration(
        color: AppColors.greyShade200,
        borderRadius: BorderRadius.circular(D.sizeSmall),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(D.sizeSmall),
        ),
        elevation: D.sizeXSmall,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AzkarCategoryScreen(
                  azkar: azkarDataList[index].toString().trim(),
                ),
              ),
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
