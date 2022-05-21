import 'package:flutter/material.dart';
import '../resources/color_manager.dart';
import '../resources/values_manager.dart';
import '../../data/models/azan/azan.dart';

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
            bottom: AppSize.s40,
            right: AppSize.s20,
          ),
          child: Text(
            azan.results.datetime[0].date.gregorian.toString(),
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: ColorManager.white),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              azan.results.location.city,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: ColorManager.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on,
                  color: ColorManager.primary,
                  size: AppSize.s20,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: AppSize.s40,
                    left: AppSize.s20,
                  ),
                  child: Text(
                    azan.results.location.country,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(color: ColorManager.white),
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
