import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:great_quran/feature/feelings/logic/models/feeling_item_model.dart';
import 'package:great_quran/feature/feelings/logic/models/feeling_verse_model.dart';
import 'package:great_quran/feature/feelings/view/screens/feeling_verses_screen.dart';
import 'package:great_quran/feature/feelings/view/widgets/verse_audio_player_bar.dart';
import 'package:great_quran/feature/feelings/view/widgets/verse_page_card.dart';
import 'package:great_quran/feature/feelings/view/widgets/verse_progress_indicator_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const mockFeeling = FeelingItemModel(
    id: "anxiety",
    title: "قلق",
    icon: "assets/images/feelings/anxiety.png",
    verses: [
      FeelingVerseModel(
        id: 'anxiety-1',
        surahNumber: 9,
        surahName: "التوبة",
        ayahNumber: 51,
        ayahText: "قُل لَّن يُصِيبَنَا إِلَّا مَا كَتَبَ اللَّهُ لَنَا",
        comfortMessage: "لن يصيبك إلا ما كتب الله لك، فألقِ حمولك عليه.",
      ),
      FeelingVerseModel(
        id: 'anxiety-2',
        surahNumber: 13,
        surahName: "الرعد",
        ayahNumber: 28,
        ayahText: "أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ",
        comfortMessage: "بذكر الله تسكن النفوس وتذهب المخاوف.",
      ),
    ],
  );

  group('FeelingVersesScreen Widget Tests', () {
    testWidgets('renders first verse card with 4 essential elements only',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: FeelingVersesScreen(feeling: mockFeeling),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // App bar & navigation
      expect(find.text("قلق"), findsOneWidget);
      expect(find.text("1 / 2"), findsOneWidget);
      expect(find.byType(VerseProgressIndicatorWidget), findsOneWidget);
      expect(find.byType(VersePageCard), findsOneWidget);
      expect(find.byType(VerseAudioPlayerBar), findsOneWidget);

      // Feeling Image removed as requested
      expect(find.byType(Image), findsNothing);

      // Element 1: Surah name & Ayah number
      expect(find.text("التوبة • الآية 51"), findsOneWidget);

      // Element 2: Full Quranic Ayah text
      expect(find.text("قُل لَّن يُصِيبَنَا إِلَّا مَا كَتَبَ اللَّهُ لَنَا"),
          findsOneWidget);

      // Element 3: Audio recitation listening button with Husary reciter
      expect(find.text("استمع للتلاوة"), findsOneWidget);
      expect(find.text("بصوت الشيخ محمود خليل الحصري"), findsOneWidget);

      // Verify removed elements are NOT present in the details UI
      expect(find.text("لن يصيبك إلا ما كتب الله لك، فألقِ حمولك عليه."),
          findsNothing);
      expect(find.byIcon(Icons.menu_book_rounded), findsNothing);

      // Bottom swipe hint
      expect(
          find.text("اسحب يميناً أو يساراً للتنقل بين الآيات"), findsOneWidget);
    });

    testWidgets('swiping page changes to next verse and updates counter',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: FeelingVersesScreen(feeling: mockFeeling),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text("1 / 2"), findsOneWidget);

      // Drag left to go to next page
      await tester.drag(find.byType(PageView), const Offset(-500, 0));
      await tester.pumpAndSettle();

      expect(find.text("2 / 2"), findsOneWidget);
      expect(find.text("الرعد • الآية 28"), findsOneWidget);
      expect(find.text("أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ"),
          findsOneWidget);
      expect(find.text("بذكر الله تسكن النفوس وتذهب المخاوف."), findsNothing);
    });
  });
}
