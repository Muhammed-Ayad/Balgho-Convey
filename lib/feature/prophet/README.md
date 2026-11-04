# Prophet Feature Package

## Overview
Presents educational topics, morals, biography (Seerah), and characteristics of Prophet Muhammad ﷺ with keyword search and category filtering.

## Interface
- `[lib/feature/prophet/logic/models/prophet_topic.dart:ProphetTopic]` - Model representing a prophetic topic with title, category, summary, hadiths, and references.
- `[lib/feature/prophet/logic/repo/prophet_repository.dart:IProphetRepository]` - Repository contract defining topic and category retrieval.
- `[lib/feature/prophet/logic/repo/prophet_repository.dart:ProphetRepository]` - Static repository providing compiled topics.
- `[lib/feature/prophet/logic/repo/prophet_repository.dart:ProphetRepository.provider]` - Riverpod provider exposing `IProphetRepository`.
- `[lib/feature/prophet/logic/providers/prophet_provider.dart:prophetCategoriesProvider]` - Provider returning all topic category strings.
- `[lib/feature/prophet/logic/providers/prophet_provider.dart:ProphetFilterNotifier]` - StateNotifier managing search text and selected category.
- `[lib/feature/prophet/logic/providers/prophet_provider.dart:ProphetFilterNotifier.provider]` - Riverpod provider for filter state.
- `[lib/feature/prophet/logic/providers/prophet_provider.dart:filteredProphetTopicsProvider]` - Derived provider computing topics matching category and search filter.
- `[lib/feature/prophet/view/screens/prophet_screen.dart:ProphetScreen]` - Main list screen with search bar, filter chips, and topic cards.
- `[lib/feature/prophet/view/screens/prophet_detail_screen.dart:ProphetDetailScreen]` - Detail screen presenting full study and references for a topic.
- `[lib/feature/prophet/view/widgets/prophet_topic_card.dart:ProphetTopicCard]` - Summary card navigating to topic details.
- `[lib/feature/prophet/view/widgets/prophet_search_and_chips.dart:ProphetSearchAndChips]` - Search field and category filter chip bar.
- `[lib/feature/prophet/view/widgets/prophet_header_banner.dart:ProphetHeaderBanner]` - Aesthetic introductory header.

## Invariants
- `[lib/feature/prophet/logic/providers/prophet_provider.dart:filteredProphetTopicsProvider]` filters normalize Arabic text for consistent search hits.

## Side Effects
- Copies topic text to system clipboard.
- Dispatches native system share sheet via `share_plus`.

## Verification
- Run: `flutter test test/prophet_test.dart`
