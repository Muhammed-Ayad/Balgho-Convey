import 'package:flutter/material.dart';
import 'package:great_quran/blocs/models/azan/azan.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/helpers/utilities.dart';
import 'package:great_quran/theme/colors.dart';
import 'package:great_quran/theme/dimensions.dart';
import 'package:great_quran/resources/strings_manager.dart';
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
    var newDate = DateTime.parse(Utilities.dateTimeNow() + " " + time);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: D.sizeLarge,
        vertical: D.sizeXSmall,
      ),
      child: Container(
        padding: const EdgeInsets.all(
          D.sizeLarge,
        ),
        height: context.heightR(0.2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(D.sizeMedium),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey,
              blurRadius: D.sizeXSmall,
            )
          ],
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [AppColors.linearGradient1, AppColors.linearGradient2],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date,
              style: context.textTheme.titleMedium!
                  .copyWith(color: AppColors.white),
            ),
            Text(
              DateFormat.jm().format(newDate),
              style: context.textTheme.titleMedium!
                  .copyWith(color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
