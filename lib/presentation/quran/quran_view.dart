import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/constants.dart';
import '../resources/strings_manager.dart';
import '../../animation/bottom_animation.dart';
import '../../business_logic/cubit/quran/quran_cubit.dart';

import '../widgets/appbar_widget.dart';
import 'quran_item.dart';

class QuranView extends StatelessWidget {
  const QuranView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
          AppStrings.quranGreat, Constants.elevationAppBarOne, context),
      body: BlocConsumer<QuranCubit, QuranState>(
        listener: (context, state) {
          if (state.status == QuranStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error.errMsg),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == QuranStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.status == QuranStatus.error) {
            return Center(
              child: Text(
                AppStrings.error,
                style: Theme.of(context).textTheme.displayMedium,
              ),
            );
          }
          return ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: state.surah.length,
            itemBuilder: (BuildContext context, int index) {
              return WidgetAnimator(
                child: QuranItem(
                  surah: state.surah[index],
                  index: index,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
