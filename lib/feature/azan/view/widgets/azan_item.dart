import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/helpers/utilities.dart';
import 'package:great_quran/core/theme/colors.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/feature/azan/logic/models/azan.dart';
import 'package:intl/intl.dart';

class AzanItem extends StatelessWidget {
  final Azan data;
  const AzanItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final results = data.data.timings;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CardAzanWidget(time: results.fajr, date: context.l10n.azanFajr),
          CardAzanWidget(time: results.sunrise, date: context.l10n.azanSunrise),
          CardAzanWidget(time: results.dhuhr, date: context.l10n.azanDhuhr),
          CardAzanWidget(time: results.asr, date: context.l10n.azanAsr),
          CardAzanWidget(time: results.maghrib, date: context.l10n.azanMaghrib),
          CardAzanWidget(time: results.isha, date: context.l10n.azanIsha),
        ],
      ),
    );
  }
}

class CardAzanWidget extends StatelessWidget {
  final String time;
  final String date;

  const CardAzanWidget({
    super.key,
    required this.time,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    var newDate = DateTime.parse("${Utilities.dateTimeNow()} $time");
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: D.sizeLarge,
        vertical: D.sizeXSmall,
      ),
      child: Container(
        padding: const EdgeInsets.all(
          D.sizeLarge,
        ),
        height: context.heightR(0.1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(D.sizeMedium),
          boxShadow: [
            BoxShadow(
              color: context.colorScheme.shadow,
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
              style: context.textTheme.titleMedium!.copyWith(
                color: context.colorScheme.surface,
              ),
            ),
            Text(
              DateFormat.jm().format(newDate),
              style: context.textTheme.titleMedium!.copyWith(
                color: context.colorScheme.surface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
