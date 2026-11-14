import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/core/theme/font_manager.dart';
import 'package:great_quran/feature/feelings/logic/models/feeling_verse_model.dart';
import 'package:great_quran/feature/feelings/view/widgets/verse_audio_player_bar.dart';

class VersePageCard extends StatelessWidget {
  final FeelingVerseModel verse;
  final int index;

  const VersePageCard({
    super.key,
    required this.verse,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(
        D.sizeMedium,
        D.sizeSmall,
        D.sizeMedium,
        D.sizeMedium,
      ),
      padding: const EdgeInsets.all(D.sizeLarge),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: primary.withValues(alpha: 0.12),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. اسم السورة ورقم الآية
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: primary.withValues(alpha: 0.12),
                width: 1,
              ),
            ),
            child: Text(
              "${verse.surahName} • الآية ${verse.ayahNumber}",
              style: TextStyle(
                color: primary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),

          // 2. نص الآية القرآنية كاملًا - في المنتصف بحجم ثابت ومريح للعين
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: D.sizeSmall,
                  vertical: D.sizeMedium,
                ),
                child: Text(
                  verse.ayahText,
                  style: TextStyle(
                    fontFamily: FontFamilyNames.uthmanicFont,
                    fontSize: 24,
                    height: 2.3,
                    color: context.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
          ),

          const SizedBox(height: D.sizeSmall),

          // 3. زر الاستماع إلى التلاوة
          VerseAudioPlayerBar(
            verse: verse,
            index: index,
          ),
        ],
      ),
    );
  }
}
