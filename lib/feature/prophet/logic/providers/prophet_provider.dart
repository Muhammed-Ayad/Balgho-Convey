import 'package:great_quran/feature/prophet/logic/models/prophet_topic.dart';
import 'package:great_quran/feature/prophet/logic/repo/prophet_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final prophetCategoriesProvider = Provider<List<String>>((ref) {
  return ref.watch(ProphetRepository.provider).getCategories();
});

class ProphetFilterState {
  final String selectedCategory;
  final String searchQuery;

  const ProphetFilterState({
    this.selectedCategory = "الكل",
    this.searchQuery = "",
  });

  ProphetFilterState copyWith({
    String? selectedCategory,
    String? searchQuery,
  }) {
    return ProphetFilterState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ProphetFilterNotifier extends StateNotifier<ProphetFilterState> {
  static final provider =
      StateNotifierProvider<ProphetFilterNotifier, ProphetFilterState>((ref) {
    return ProphetFilterNotifier();
  });

  ProphetFilterNotifier() : super(const ProphetFilterState());

  void selectCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  void updateSearch(String query) {
    state = state.copyWith(searchQuery: query.trim());
  }

  void reset() {
    state = const ProphetFilterState();
  }
}

final filteredProphetTopicsProvider = Provider<List<ProphetTopic>>((ref) {
  final repo = ref.watch(ProphetRepository.provider);
  final filter = ref.watch(ProphetFilterNotifier.provider);

  List<ProphetTopic> list = repo.getTopicsByCategory(filter.selectedCategory);

  if (filter.searchQuery.isNotEmpty) {
    final q = filter.searchQuery.toLowerCase();
    list = list.where((topic) {
      return topic.title.toLowerCase().contains(q) ||
          topic.subtitle.toLowerCase().contains(q) ||
          topic.summary.toLowerCase().contains(q) ||
          topic.content.toLowerCase().contains(q);
    }).toList();
  }

  return list;
});
