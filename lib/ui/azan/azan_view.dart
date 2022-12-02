import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';
import '../../blocs/cubit/azan_time/azan_time_cubit.dart';
import 'header_azan.dart';
import 'azan_item.dart';

class AzanView extends StatelessWidget {
  const AzanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(AppSize.s30),
                        bottomLeft: Radius.circular(AppSize.s30),
                      ),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(ImageAssets.azantwo),
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: context.read<AzanTimeCubit>().getAzan(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return HeaderAzan(snapshot.data);
                      } else if (snapshot.hasError) {
                        return Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              AppStrings.pleaseConnectToTheInternet,
                              style: TextStyle(color: ColorManager.white),
                            ),
                          ),
                        );
                      }
                      return const Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 7,
              child: FutureBuilder(
                future: context.read<AzanTimeCubit>().getAzan(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return AzanItem(
                      data: snapshot.data,
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        AppStrings.pleaseConnectToTheInternet,
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
