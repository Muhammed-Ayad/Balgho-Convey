import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:great_quran/feature/feelings/logic/models/feeling_item_model.dart';
import 'package:great_quran/feature/feelings/logic/models/feeling_verse_model.dart';
import 'package:great_quran/feature/feelings/logic/repo/feelings_repository.dart';
import 'package:great_quran/feature/feelings/view/screens/feelings_screen.dart';
import 'package:great_quran/feature/feelings/view/widgets/feeling_grid_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FakeFeelingsRepository implements IFeelingsRepository {
  final List<FeelingItemModel> data;
  final bool shouldThrow;

  FakeFeelingsRepository({
    required this.data,
    this.shouldThrow = false,
  });

  @override
  Future<List<FeelingItemModel>> getFeelings() async {
    if (shouldThrow) {
      throw Exception("Failed to load feelings");
    }
    return data;
  }

  @override
  Future<FeelingItemModel?> getFeelingById(String id) async {
    if (shouldThrow) {
      throw Exception("Failed to get feeling by id");
    }
    try {
      return data.firstWhere((f) => f.id == id);
    } catch (_) {
      return null;
    }
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final mockFeelings = [
    const FeelingItemModel(
      id: "anxiety",
      title: "قلق",
      icon: "assets/images/feelings/anxiety.png",
      verses: [
        FeelingVerseModel(
          id: 1,
          surahNumber: 9,
          surahName: "التوبة",
          ayahNumber: 51,
          ayahText: "قُل لَّن يُصِيبَنَا إِلَّا مَا كَتَبَ اللَّهُ لَنَا",
          comfortMessage: "لن يصيبك إلا ما كتب الله لك، فألقِ حمولك عليه.",
        ),
      ],
    ),
    const FeelingItemModel(
      id: "sadness",
      title: "حزن",
      icon: "assets/images/feelings/sadness.png",
      verses: [
        FeelingVerseModel(
          id: 2,
          surahNumber: 9,
          surahName: "التوبة",
          ayahNumber: 40,
          ayahText: "لَا تَحْزَنْ إِنَّ اللَّهَ مَعَنَا",
          comfortMessage: "معية الله كافية لتبديد كل أحزانك.",
        ),
      ],
    ),
  ];

  group('FeelingsScreen Widget Tests', () {
    testWidgets('renders feelings cards when data is loaded successfully',
        (tester) async {
      final fakeRepo = FakeFeelingsRepository(data: mockFeelings);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            FeelingsRepository.provider.overrideWithValue(fakeRepo),
          ],
          child: const MaterialApp(
            home: FeelingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text("ما هو شعورك الآن؟"), findsOneWidget);
      expect(find.text("اختر شعورك، ودع القرآن يجيبك"), findsOneWidget);
      expect(find.byType(FeelingGridCard), findsNWidgets(2));
      expect(find.text("قلق"), findsOneWidget);
      expect(find.text("حزن"), findsOneWidget);
      expect(find.text("1 آيات"), findsNWidgets(2));
    });

    testWidgets('renders error widget when repository throws', (tester) async {
      final fakeRepo = FakeFeelingsRepository(data: [], shouldThrow: true);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            FeelingsRepository.provider.overrideWithValue(fakeRepo),
          ],
          child: const MaterialApp(
            home: FeelingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text("تعذر تحميل بيانات المشاعر"), findsOneWidget);
    });
  });
}
