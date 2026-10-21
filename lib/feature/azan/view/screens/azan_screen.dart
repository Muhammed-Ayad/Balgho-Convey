import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/routes/routes_manager.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/core/widgets/custom_app_bar.dart';
import 'package:great_quran/core/widgets/error_widget.dart';
import 'package:great_quran/core/widgets/loading_widget.dart';
import 'package:great_quran/feature/azan/logic/providers/azan_provider.dart';
import 'package:great_quran/feature/azan/view/widgets/azan_item.dart';
import 'package:great_quran/feature/azan/view/widgets/azan_sunan_card.dart';
import 'package:great_quran/feature/azan/view/widgets/header_azan.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AzanScreen extends ConsumerWidget {
  const AzanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(AzanTimeNotifier.provider);

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: CustomAppBar(
        title: "مواقيت الصلاة",
        actions: [
          IconButton(
            tooltip: "إعدادات الأذان والتنبيهات",
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => context.push(Routes.azanSettingsRoute),
          ),
        ],
      ),
      body: state.when(
        data: (data) {
          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(AzanTimeNotifier.provider.notifier).getAzan();
            },
            child: ListView(
              children: [
                HeaderAzan(data),
                AzanItem(data: data),
                const SizedBox(height: D.sizeSmall),
                AzanSunanCard(timings: data.data.timings),
                const SizedBox(height: D.sizeSmall),
                const QiblaAndDuaBannerWidget(),
                const SizedBox(height: D.sizeXXLarge),
              ],
            ),
          );
        },
        loading: () => const LoadingWidget(),
        error: (err, stack) => CustomErrorWidget(
          errorMsg: err.toString(),
          onRefresh: () {
            ref.read(AzanTimeNotifier.provider.notifier).getAzan();
          },
        ),
      ),
    );
  }
}
