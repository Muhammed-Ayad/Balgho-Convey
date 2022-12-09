import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:great_quran/blocs/models/azan/azan.dart';
import 'package:great_quran/generated/locale_keys.g.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/helpers/utilities.dart';
import 'package:great_quran/theme/colors.dart';
import 'package:great_quran/theme/dimensions.dart';

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
          _CardAzan(time: results.fajr, date: LocaleKeys.azan_fajr.tr()),
          _CardAzan(time: results.sunrise, date: LocaleKeys.azan_sunrise.tr()),
          _CardAzan(time: results.dhuhr, date: LocaleKeys.azan_dhuhr.tr()),
          _CardAzan(time: results.asr, date: LocaleKeys.azan_asr.tr()),
          _CardAzan(time: results.maghrib, date: LocaleKeys.azan_maghrib.tr()),
          _CardAzan(time: results.isha, date: LocaleKeys.azan_isha.tr()),
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
