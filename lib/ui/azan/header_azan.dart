import 'package:flutter/material.dart';
import 'package:great_quran/blocs/models/azan/azan.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/theme/colors.dart';
import 'package:great_quran/theme/dimensions.dart';

class HeaderAzan extends StatelessWidget {
  final Azan azan;
  const HeaderAzan(this.azan, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: D.size3XLarge,
            right: D.sizeXLarge,
          ),
          child: Text(
            azan.data.date.readable.toString(),
            style: context.textTheme.headlineMedium!
                .copyWith(color: AppColors.white),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'cairo',
              style: context.textTheme.headlineMedium!
                  .copyWith(color: AppColors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on,
                  color: AppColors.primary,
                  size: D.sizeXLarge,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: D.size3XLarge,
                    left: D.sizeXLarge,
                  ),
                  child: Text(
                    'cairo',
                    style: context.textTheme.headlineMedium!
                        .copyWith(color: AppColors.white),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}
