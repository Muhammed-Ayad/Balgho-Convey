import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/feature/azan/logic/models/azan.dart';

class HeaderAzan extends StatelessWidget {
  final Azan azan;
  const HeaderAzan(this.azan, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(D.sizeXXLarge),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              color: context.colorScheme.surface,
            ),
          ),
          Column(
            children: [
              Text(
                azan.data.date.readable,
                style: context.textTheme.headlineMedium!
                    .copyWith(color: context.colorScheme.surface),
              ),
              Text(
                azan.data.date.hijri.weekday.ar,
                style: context.textTheme.headlineMedium!
                    .copyWith(color: context.colorScheme.surface),
              ),
            ],
          )
        ],
      ),
    );
  }
}
