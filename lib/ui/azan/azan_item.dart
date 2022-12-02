import 'package:flutter/material.dart';
import '../resources/color_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';

import '../../data/models/azan/azan.dart';
import 'package:intl/intl.dart';

class AzanItem extends StatelessWidget {
  final Azan data;
  const AzanItem({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final results = data.results.datetime[0].times;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildCardAzan(results.fajr, AppStrings.fajr, context),
          buildCardAzan(results.sunrise, AppStrings.sunrise, context),
          buildCardAzan(results.dhuhr, AppStrings.dhuhr, context),
          buildCardAzan(results.asr, AppStrings.asr, context),
          buildCardAzan(results.maghrib, AppStrings.maghrib, context),
          buildCardAzan(results.isha, AppStrings.isha, context),
        ],
      ),
    );
  }

  Widget buildCardAzan(String time, String date, context) {
    String formattedDate =
        DateFormat(AppStrings.dateFormat).format(DateTime.now());
    var newDate = DateTime.parse(formattedDate + " " + time);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p16,
        vertical: AppPadding.p4,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppPadding.p16),
        height: AppSize.s75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.s10),
          boxShadow: [
            BoxShadow(color: ColorManager.grey, blurRadius: AppSize.s5)
          ],
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              ColorManager.linearGradient1,
              ColorManager.linearGradient2
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: ColorManager.white),
            ),
            Text(
              DateFormat.jm().format(newDate),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: ColorManager.white),
            ),
          ],
        ),
      ),
    );
  }
}
