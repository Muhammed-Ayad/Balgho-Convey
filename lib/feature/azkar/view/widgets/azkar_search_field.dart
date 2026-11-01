import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';

class AzkarSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const AzkarSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: D.sizeMedium,
        vertical: D.sizeSmall,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: "ابحث في الأذكار والأدعية...",
          hintStyle: context.textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade500,
            fontSize: 14,
          ),
          prefixIcon: Icon(Icons.search_rounded, color: primary),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: onClear,
                )
              : null,
          filled: true,
          fillColor: context.colorScheme.surface,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 16.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(D.sizeLarge),
            borderSide: BorderSide(
              color: primary.withValues(alpha: 0.15),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(D.sizeLarge),
            borderSide: BorderSide(
              color: primary.withValues(alpha: 0.15),
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
