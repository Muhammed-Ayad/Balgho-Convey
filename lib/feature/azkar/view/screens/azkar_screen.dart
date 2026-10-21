import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/helpers/ui_helpers.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/core/widgets/custom_app_bar.dart';
import 'package:great_quran/core/widgets/loading_widget.dart';
import 'package:great_quran/feature/azkar/logic/data/azkar_filter.dart';
import 'package:great_quran/feature/azkar/logic/providers/notifications_subscription_notifier.dart';
import 'package:great_quran/feature/azkar/view/widgets/azkar_category_tile.dart';
import 'package:great_quran/feature/azkar/view/widgets/azkar_search_field.dart';
import 'package:great_quran/feature/azkar/view/widgets/azkar_section_chips.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AzkarScreen extends ConsumerStatefulWidget {
  const AzkarScreen({super.key});

  @override
  ConsumerState<AzkarScreen> createState() => _AzkarScreenState();
}

class _AzkarScreenState extends ConsumerState<AzkarScreen> {
  final TextEditingController _searchController = TextEditingController();
  AzkarSection _selectedSection = AzkarSection.all;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    UiHelper.postBuild((_) async {
      await ref
          .read(NotificationsSubscriptionNotifier.provider.notifier)
          .fetchData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onSectionSelected(AzkarSection section) {
    setState(() {
      _selectedSection = section;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = AzkarFilterHelper.filter(
      section: _selectedSection,
      searchQuery: _searchQuery,
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: context.l10n.titleAzkar,
        actions: const [
          AzkarNotificationActionButton(),
        ],
      ),
      body: Column(
        children: [
          AzkarSearchField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            onClear: _clearSearch,
          ),
          AzkarSectionChips(
            selectedSection: _selectedSection,
            onSelect: _onSectionSelected,
          ),
          const SizedBox(height: 4),
          Expanded(
            child: filteredList.isEmpty
                ? const AzkarEmptySearchResultWidget()
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: D.sizeLarge),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      return AzkarCategoryTile(
                        title: filteredList[index],
                        index: index,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class AzkarNotificationActionButton extends ConsumerWidget {
  const AzkarNotificationActionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(NotificationsSubscriptionNotifier.provider);
    final notifier =
        ref.read(NotificationsSubscriptionNotifier.provider.notifier);

    return state.when(
      data: (isActive) {
        return IconButton(
          onPressed: () async {
            await notifier.toggle();
          },
          icon: Icon(
            isActive
                ? Icons.notifications_active
                : Icons.notification_add_outlined,
            color: isActive ? Colors.amberAccent : null,
          ),
          tooltip: "تنبيهات الأذكار",
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(D.sizeSmall),
        child: LoadingWidget(
          size: D.size3XLarge,
        ),
      ),
      error: (err, stack) => IconButton(
        onPressed: () async {
          await notifier.fetchData();
        },
        icon: Icon(
          Icons.refresh,
          size: D.size3XLarge,
          color: context.colorScheme.error,
        ),
      ),
    );
  }
}

class AzkarEmptySearchResultWidget extends StatelessWidget {
  const AzkarEmptySearchResultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: D.sizeMedium),
          Text(
            "لا توجد أذكار مطابقة للبحث",
            style: context.textTheme.titleMedium?.copyWith(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
