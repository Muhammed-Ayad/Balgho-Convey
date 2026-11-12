import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/core/theme/font_manager.dart';
import 'package:great_quran/feature/feelings/logic/models/feeling_verse_model.dart';
import 'package:great_quran/feature/feelings/view/widgets/verse_audio_player_bar.dart';
import 'package:great_quran/feature/feelings/view/widgets/verse_context_widget.dart';

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

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: D.sizeMedium,
          vertical: D.sizeSmall,
        ),
        padding: const EdgeInsets.all(D.sizeLarge),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(D.sizeLarge),
          border: Border.all(
            color: primary.withValues(alpha: 0.14),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
   
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: D.sizeMedium,
                  vertical: D.sizeSmall / 2,
                ),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      size: 16,
                      color: primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "${verse.surahName} • الآية ${verse.ayahNumber}",
                      style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: D.sizeLarge),

             
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: D.sizeMedium,
                  vertical: D.sizeSmall,
                ),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: primary.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Text(
                  verse.comfortMessage,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: primary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              if (verse.context != null || verse.tags.isNotEmpty) ...[
                const SizedBox(height: D.sizeSmall),
                VerseContextWidget(
                  contextText: verse.context ?? '',
                  tags: verse.tags,
                ),
              ],
              const SizedBox(height: D.sizeLarge),

            
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: D.sizeSmall),
                child: Text(
                  verse.ayahText,
                  style: TextStyle(
                    fontFamily: FontFamilyNames.messiriFont,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    height: 2.1,
                    color: context.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: D.sizeXLarge),

            
              VerseAudioPlayerBar(
                verse: verse,
                index: index,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
