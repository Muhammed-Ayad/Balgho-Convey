import 'package:flutter_test/flutter_test.dart';
import 'package:great_quran/feature/feelings/logic/models/feeling_item_model.dart';
import 'package:great_quran/feature/feelings/logic/models/feeling_verse_model.dart';

void main() {
  group('FeelingVerseModel Tests', () {
    test('Calculates EveryAyah 6-digits dynamic audioUrl correctly', () {
      const verse = FeelingVerseModel(
        id: 'anxiety-1',
        surahName: 'سورة التوبة',
        surahNumber: 9,
        ayahNumber: 51,
        ayahText: 'قُل لَّن يُصِيبَنَا إِلَّا مَا كَتَبَ اللَّهُ لَنَا',
        comfortMessage: 'لن يصيبك إلا ما كتبه الله لك',
      );

      expect(
        verse.audioUrl,
        'https://everyayah.com/data/Husary_128kbps/009051.mp3',
      );
    });

    test('Calculates audioUrl correctly for 3-digit Surah and Ayah numbers',
        () {
      const verse = FeelingVerseModel(
        id: 'sadness-3',
        surahName: 'سورة البقرة',
        surahNumber: 2,
        ayahNumber: 286,
        ayahText: 'لَا يُكَلِّفُ ٱللَّهُ نَفْسًا إِلَّا وُسْعَهَا',
        comfortMessage: 'رسالة مواساة',
        context: 'سياق الآية',
        tags: ['صبر', 'رحمة'],
      );

      expect(
        verse.audioUrl,
        'https://everyayah.com/data/Husary_128kbps/002286.mp3',
      );
      expect(verse.context, 'سياق الآية');
      expect(verse.tags, ['صبر', 'رحمة']);
    });

    test('Serializes to and from JSON correctly', () {
      final jsonMap = {
        'id': 'anxiety-3',
        'surahName': 'سورة الشرح',
        'surahNumber': 94,
        'ayahNumber': 5,
        'ayahText': 'فَإِنَّ مَعَ ٱلْعُسْرِ يُسْرًا',
        'comfortMessage': 'مع العسر يسر',
        'context': 'تسلية للنبي ﷺ',
        'tags': ['فرج', 'يسر'],
      };

      final model = FeelingVerseModel.fromJson(jsonMap);
      expect(model.id, 'anxiety-3');
      expect(model.surahName, 'سورة الشرح');
      expect(model.surahNumber, 94);
      expect(model.ayahNumber, 5);
      expect(model.ayahText, 'فَإِنَّ مَعَ ٱلْعُسْرِ يُسْرًا');
      expect(model.comfortMessage, 'مع العسر يسر');
      expect(model.context, 'تسلية للنبي ﷺ');
      expect(model.tags, ['فرج', 'يسر']);

      final serialized = model.toJson();
      expect(serialized, jsonMap);
    });
  });

  group('FeelingItemModel Tests', () {
    test('Serializes and deserializes feeling with verses list', () {
      final jsonMap = {
        'id': 'anxiety',
        'title': 'قلق',
        'icon': 'assets/images/feelings/anxiety.png',
        'disclaimer': 'تنبيه طبي',
        'verses': [
          {
            'id': 'anxiety-1',
            'surahName': 'سورة التوبة',
            'surahNumber': 9,
            'ayahNumber': 51,
            'ayahText': 'قُل لَّن يُصِيبَنَآ',
            'comfortMessage': 'اطمئن',
            'context': 'سياق التوبة',
            'tags': ['توكل'],
          },
          {
            'id': 'anxiety-2',
            'surahName': 'سورة الرعد',
            'surahNumber': 13,
            'ayahNumber': 28,
            'ayahText': 'أَلَا بِذِكْرِ ٱللَّهِ تَطْمَئِنُّ ٱلْقُلُوبُ',
            'comfortMessage': 'اذكر ربك',
            'tags': ['طمأنينة'],
          }
        ]
      };

      final feeling = FeelingItemModel.fromJson(jsonMap);
      expect(feeling.id, 'anxiety');
      expect(feeling.title, 'قلق');
      expect(feeling.icon, 'assets/images/feelings/anxiety.png');
      expect(feeling.disclaimer, 'تنبيه طبي');
      expect(feeling.versesCount, 2);
      expect(feeling.verses.first.ayahNumber, 51);
      expect(feeling.verses.first.id, 'anxiety-1');
      expect(feeling.verses.last.surahNumber, 13);
      expect(feeling.verses.last.id, 'anxiety-2');

      final serialized = feeling.toJson();
      expect(serialized['id'], 'anxiety');
      expect(serialized['disclaimer'], 'تنبيه طبي');
      expect((serialized['verses'] as List).length, 2);
    });
  });
}
