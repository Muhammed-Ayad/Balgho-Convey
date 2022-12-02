import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/blocs/providers/azan_time_provider.dart';
import 'package:great_quran/ui/resources/assets_manager.dart';
import 'package:great_quran/ui/resources/values_manager.dart';
import 'header_azan.dart';
import 'azan_item.dart';

class AzanScreen extends ConsumerWidget {
  const AzanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        body: Consumer(builder: (_, ref, __) {
          final state = ref.watch(AzanTimeNotifier.provider);
          return state.when(
            data: (data) {
              return Column(
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
                        HeaderAzan(data),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: AzanItem(
                      data: data,
                    ),
                  ),
                ],
              );
            },
            loading: () => const CircularProgressIndicator.adaptive(),
            error: (_) {
              return const Center(
                child: Text('Error'),
              );
            },
          );
        }),
      ),
    );
  }
}
