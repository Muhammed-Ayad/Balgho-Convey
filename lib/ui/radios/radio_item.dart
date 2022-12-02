import 'package:flutter/material.dart';
import '../resources/color_manager.dart';
import '../resources/values_manager.dart';
import '../../data/models/radios/radios.dart';
import 'audio_page.dart';

class RadioItem extends StatelessWidget {
  final Radios radios;
  const RadioItem({Key? key, required this.radios}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AudioPage(radios: radios),
          ),
        );
      },
      child: Card(
        elevation: AppSize.s5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s16),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: BorderRadius.circular(AppSize.s16),
          ),
          height: AppSize.s70,
          child: Padding(
            padding: const EdgeInsets.all(AppSize.s8),
            child: Row(
              children: [
                Icon(
                  Icons.radio_outlined,
                  color: ColorManager.primary,
                  size: AppSize.s35,
                ),
                const SizedBox(width: AppSize.s10),
                Flexible(
                  child: Text(
                    radios.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
