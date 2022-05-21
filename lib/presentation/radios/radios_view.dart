import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/constants.dart';
import '../resources/color_manager.dart';
import '../resources/strings_manager.dart';
import '../../animation/bottom_animation.dart';
import '../../business_logic/cubit/radios/radio_cubit.dart';
import 'radio_item.dart';

import '../widgets/appbar_widget.dart';

class RadiosView extends StatelessWidget {
  const RadiosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        AppStrings.radio,
        Constants.elevationAppBarOne,
        context,
      ),
      body: BlocConsumer<RadioCubit, RadioState>(
        listener: (context, state) {
          if (state.status == RadioStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error.errMsg),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == RadioStatus.loading) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorManager.black38,
              ),
            );
          }

          if (state.status == RadioStatus.error) {
            return Center(
              child: Text(
                AppStrings.error,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            );
          }
          return ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: state.radio.length,
            itemBuilder: (BuildContext context, int index) {
              return WidgetAnimator(
                child: RadioItem(
                  radios: state.radio[index],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
