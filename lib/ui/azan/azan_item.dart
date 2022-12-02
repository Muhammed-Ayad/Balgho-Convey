import 'package:flutter/material.dart';
import 'package:great_quran/blocs/models/azan/azan.dart';
import 'package:great_quran/ui/resources/color_manager.dart';
import 'package:great_quran/ui/resources/strings_manager.dart';
import 'package:great_quran/ui/resources/values_manager.dart';
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
          _CardAzan(time: results.fajr, date: AppStrings.fajr),
          _CardAzan(time: results.sunrise, date: AppStrings.sunrise),
          _CardAzan(time: results.dhuhr, date: AppStrings.dhuhr),
          _CardAzan(time: results.asr, date: AppStrings.asr),
          _CardAzan(time: results.maghrib, date: AppStrings.maghrib),
          _CardAzan(time: results.isha, date: AppStrings.isha),
        ],
      ),
    );
  }
}

class _CardAzan extends StatelessWidget {
  final String time;
  final String date;

  const _CardAzan({
    Key? key,
    required this.time,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
