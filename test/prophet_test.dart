import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:great_quran/feature/prophet/logic/models/prophet_topic.dart';
import 'package:great_quran/feature/prophet/logic/providers/prophet_provider.dart';
import 'package:great_quran/feature/prophet/logic/repo/prophet_repository.dart';
import 'package:great_quran/feature/prophet/view/screens/prophet_detail_screen.dart';
import 'package:great_quran/feature/prophet/view/screens/prophet_screen.dart';
import 'package:great_quran/feature/prophet/view/widgets/prophet_header_banner.dart';
import 'package:great_quran/feature/prophet/view/widgets/prophet_topic_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProphetRepository and Data Validity Tests', () {
    final repo = ProphetRepository();

    test('All topics have valid titles, contents, and trusted sources', () {
      final topics = repo.getAllTopics();
      expect(topics.isNotEmpty, true);

      for (final topic in topics) {
        expect(topic.id.isNotEmpty, true);
        expect(topic.title.isNotEmpty, true);
        expect(topic.category.isNotEmpty, true);
        expect(topic.content.isNotEmpty, true);
        expect(topic.summary.isNotEmpty, true);
        // Every single topic MUST have authentic sources
        expect(topic.sources.isNotEmpty, true);
      }
    });

    test('Categories list contains all expected sections', () {
      final categories = repo.getCategories();
      expect(categories.contains("الكل"), true);
      expect(categories.contains("النسب الشريف والمولد والنشأة"), true);
      expect(categories.contains("شمائله وصفاته الخَلقية ﷺ"), true);
      expect(categories.contains("أخلاقه وصفاته الخُلقية ﷺ"), true);
      expect(categories.contains("زوجاته أمهات المؤمنين ﷺ"), true);
      expect(categories.contains("أولاده وبناته ﷺ"), true);
      expect(categories.contains("معجزاته ودلائل نبوته الكبرى"), true);
      expect(categories.contains("محطات بارزة في سيرته وغزواته"), true);
      expect(categories.contains("حقوقه وواجباتنا نحوه ﷺ"), true);
    });

    test('Filtering by category returns only matching topics', () {
      final filtered = repo.getTopicsByCategory("أخلاقه وصفاته الخُلقية ﷺ");
      expect(filtered.isNotEmpty, true);
      for (final topic in filtered) {
        expect(topic.category, "أخلاقه وصفاته الخُلقية ﷺ");
      }
    });

    test('Topic serialization and deserialization works', () {
      final original = repo.getAllTopics().first;
      final json = original.toJson();
      final restored = ProphetTopic.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.title, original.title);
      expect(restored.sources.length, original.sources.length);
    });
  });

  group('Prophet Provider Filtering Tests', () {
    test('Filtering provider updates when search query is entered', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final initialList = container.read(filteredProphetTopicsProvider);
      expect(initialList.isNotEmpty, true);

      // Search for a specific keyword
      container
          .read(ProphetFilterNotifier.provider.notifier)
          .updateSearch("القرآن");
      final searchedList = container.read(filteredProphetTopicsProvider);

      expect(searchedList.isNotEmpty, true);
      expect(searchedList.length <= initialList.length, true);
    });
  });

  group('Prophet Widgets Tests', () {
    testWidgets('ProphetHeaderBanner renders title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProphetHeaderBanner(),
          ),
        ),
      );

      expect(find.text("مُحَمَّدٌ رَسُولُ اللَّهِ ﷺ"), findsOneWidget);
    });

    testWidgets('ProphetTopicCard renders topic data', (tester) async {
      final repo = ProphetRepository();
      final topic = repo.getAllTopics().first;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProphetTopicCard(topic: topic),
          ),
        ),
      );

      expect(find.text(topic.title), findsOneWidget);
      expect(find.text(topic.category), findsOneWidget);
    });

    testWidgets('ProphetScreen renders with ProviderScope', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ProphetScreen(),
          ),
        ),
      );

      expect(find.text("اعرف نبيك ﷺ"), findsOneWidget);
      expect(find.byType(ProphetHeaderBanner), findsOneWidget);
    });

    testWidgets('ProphetDetailScreen renders detail sections', (tester) async {
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final repo = ProphetRepository();
      final topic = repo.getAllTopics().first;

      await tester.pumpWidget(
        MaterialApp(
          home: ProphetDetailScreen(topic: topic),
        ),
      );

      expect(find.text(topic.title), findsWidgets);
      expect(find.text("التفاصيل والشرح الموثق"), findsOneWidget);
      expect(find.text("المصادر والمراجع الإسلامية المعتمدة"), findsOneWidget);
    });
  });
}
