import 'package:flutter/material.dart';
import 'package:great_quran/blocs/models/azan/azan.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/theme/dimensions.dart';

class HeaderAzan extends StatelessWidget {
  final Azan azan;
  const HeaderAzan(this.azan, {Key? key}) : super(key: key);

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
                azan.data.date.readable.toString(),
                style: context.textTheme.headlineMedium!
                    .copyWith(color: context.colorScheme.background),
              ),
              Text(
                azan.data.date.hijri.weekday.ar.toString(),
                style: context.textTheme.headlineMedium!
                    .copyWith(color: context.colorScheme.background),
              ),
            ],
          )
        ],
      ),
    );
  }
}
