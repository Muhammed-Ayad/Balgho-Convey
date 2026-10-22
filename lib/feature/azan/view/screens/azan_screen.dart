import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/routes/routes_manager.dart';
import 'package:great_quran/core/services/location_service.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/core/widgets/custom_app_bar.dart';
import 'package:great_quran/core/widgets/error_widget.dart';
import 'package:great_quran/core/widgets/loading_widget.dart';
import 'package:great_quran/core/widgets/location_rationale_dialog.dart';
import 'package:great_quran/feature/azan/logic/providers/azan_provider.dart';
import 'package:great_quran/feature/azan/view/widgets/azan_item.dart';
import 'package:great_quran/feature/azan/view/widgets/azan_sunan_card.dart';
import 'package:great_quran/feature/azan/view/widgets/header_azan.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AzanScreen extends ConsumerStatefulWidget {
  const AzanScreen({super.key});

  @override
  ConsumerState<AzanScreen> createState() => _AzanScreenState();
}

class _AzanScreenState extends ConsumerState<AzanScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLocationOnEnter();
    });
  }

  Future<void> _checkLocationOnEnter() async {
    final locationService = ref.read(LocationService.provider);
    final hasPerm = await locationService.hasPermission();
    if (!hasPerm && mounted) {
      LocationRationaleDialog.show(
        context,
        onAllow: () async {
          await ref
              .read(AzanTimeNotifier.provider.notifier)
              .getAzan(allowPrompt: true);
        },
      );
    }
  }

  Future<void> _refreshWithLocationPrompt() async {
    final locationService = ref.read(LocationService.provider);
    final hasPerm = await locationService.hasPermission();
    if (!hasPerm && mounted) {
      LocationRationaleDialog.show(
        context,
        onAllow: () async {
          await ref
              .read(AzanTimeNotifier.provider.notifier)
              .getAzan(allowPrompt: true);
        },
      );
    } else {
      await ref
          .read(AzanTimeNotifier.provider.notifier)
          .getAzan(allowPrompt: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(AzanTimeNotifier.provider);

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: CustomAppBar(
        title: "مواقيت الصلاة",
        actions: [
          IconButton(
            tooltip: "تحديد الموقع الحالي",
            icon: const Icon(Icons.my_location_rounded),
            onPressed: _refreshWithLocationPrompt,
          ),
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
            onRefresh: _refreshWithLocationPrompt,
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
          onRefresh: _refreshWithLocationPrompt,
        ),
      ),
    );
  }
}
