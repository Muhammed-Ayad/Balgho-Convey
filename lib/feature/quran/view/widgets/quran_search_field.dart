import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/feature/quran/logic/providers/quran_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class QuranSearchField extends ConsumerStatefulWidget {
  const QuranSearchField({super.key});

  @override
  ConsumerState<QuranSearchField> createState() => _QuranSearchFieldState();
}

class _QuranSearchFieldState extends ConsumerState<QuranSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(quranSearchQueryProvider),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;
    final currentQuery = ref.watch(quranSearchQueryProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: D.sizeMedium,
        vertical: D.sizeSmall,
      ),
      child: TextField(
        controller: _controller,
        onChanged: (val) {
          ref.read(quranSearchQueryProvider.notifier).state = val;
        },
        decoration: InputDecoration(
          hintText: "ابحث باسم السورة أو رقمها...",
          prefixIcon: Icon(Icons.search, color: primary),
          suffixIcon: currentQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 20),
                  onPressed: () {
                    _controller.clear();
                    ref.read(quranSearchQueryProvider.notifier).state = '';
                  },
                )
              : null,
          filled: true,
          fillColor: context.colorScheme.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: D.sizeMedium,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(D.sizeLarge),
            borderSide: BorderSide(
              color: primary.withValues(alpha: 0.2),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(D.sizeLarge),
            borderSide: BorderSide(
              color: primary.withValues(alpha: 0.2),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(D.sizeLarge),
            borderSide: BorderSide(
              color: primary,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
