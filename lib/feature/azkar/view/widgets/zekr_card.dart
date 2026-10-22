import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/constants.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/feature/azkar/logic/providers/azkar_category_provider.dart';
import 'package:great_quran/feature/favorites/logic/models/favorite_item.dart';
import 'package:great_quran/feature/favorites/logic/providers/favorites_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

class ZekrCard extends ConsumerStatefulWidget {
  final ZekrProgressItem item;
  final String category;

  const ZekrCard({
    super.key,
    required this.item,
    required this.category,
  });

  @override
  ConsumerState<ZekrCard> createState() => _ZekrCardState();
}

class _ZekrCardState extends ConsumerState<ZekrCard>
    with SingleTickerProviderStateMixin {
  bool _isExiting = false;

  void _handleTap() {
    if (_isExiting || widget.item.isCompleted) return;

    if (widget.item.remainingCount <= 1) {
      setState(() {
        _isExiting = true;
      });
      Future.delayed(const Duration(milliseconds: 350), () {
        if (mounted) {
          ref
              .read(azkarCategoryProvider(widget.category).notifier)
              .increment(widget.item.id);
        }
      });
    } else {
      ref
          .read(azkarCategoryProvider(widget.category).notifier)
          .increment(widget.item.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final item = widget.item;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _isExiting ? 0.0 : 1.0,
      curve: Curves.easeInOut,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: _isExiting
            ? const SizedBox(width: double.infinity, height: 0)
            : Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: D.sizeMedium,
                  vertical: D.sizeSmall,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(D.sizeLarge),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.2),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(D.sizeLarge),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(D.sizeLarge),
                    splashColor: colorScheme.primary.withValues(alpha: 0.12),
                    highlightColor: colorScheme.primary.withValues(alpha: 0.06),
                    onTap: _handleTap,
                    child: Padding(
                      padding: const EdgeInsets.all(D.sizeLarge),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ZekrCountBadgeWidget(
                                remainingCount: item.remainingCount,
                                targetCount: item.targetCount,
                                isExiting: _isExiting,
                              ),
                              ZekrActionButtonsWidget(
                                zekrText: item.zekr.zekr,
                                zekrId:
                                    'zekr_${item.id}_${item.zekr.zekr.hashCode}',
                                category: widget.category,
                              ),
                            ],
                          ),
                          const SizedBox(height: D.sizeMedium),
                          Text(
                            item.zekr.zekr,
                            style: context.textTheme.headlineMedium?.copyWith(
                              fontSize: 19,
                              height: 1.8,
                              fontWeight: FontWeight.w600,
                              color: theme.brightness == Brightness.dark
                                  ? const Color(0xFFF8FAFC)
                                  : const Color(0xFF1E293B),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (item.zekr.description.isNotEmpty ||
                              item.zekr.reference.isNotEmpty) ...[
                            const SizedBox(height: D.sizeMedium),
                            ZekrFadlWidget(
                              description: item.zekr.description,
                              reference: item.zekr.reference,
                            ),
                          ],
                          const SizedBox(height: D.sizeSmall),
                          Text(
                            "اضغط في أي مكان لاحتساب التكرار",
                            style: context.textTheme.bodySmall?.copyWith(
                              fontSize: 11,
                              color: colorScheme.primary.withValues(alpha: 0.6),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class ZekrCountBadgeWidget extends StatelessWidget {
  final int remainingCount;
  final int targetCount;
  final bool isExiting;

  const ZekrCountBadgeWidget({
    super.key,
    required this.remainingCount,
    required this.targetCount,
    required this.isExiting,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    if (isExiting || remainingCount <= 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.green.shade600,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check, size: 16, color: Colors.white),
            SizedBox(width: 4),
            Text(
              "اكتمل",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.touch_app_outlined, size: 15, color: primary),
          const SizedBox(width: 6),
          Text(
            "متبقي: $remainingCount من $targetCount",
            style: TextStyle(
              color: primary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class ZekrFadlWidget extends StatelessWidget {
  final String description;
  final String reference;

  const ZekrFadlWidget({
    super.key,
    required this.description,
    required this.reference,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = context.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(D.sizeSmall),
      decoration: BoxDecoration(
        color:
            isDark ? primary.withValues(alpha: 0.12) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(D.sizeSmall),
        border: Border.all(
          color: primary.withValues(alpha: isDark ? 0.25 : 0.15),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (description.isNotEmpty)
            Text(
              description,
              style: context.textTheme.bodySmall?.copyWith(
                fontSize: 12,
                height: 1.5,
                color:
                    isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
              ),
            ),
          if (reference.isNotEmpty) ...[
            if (description.isNotEmpty) const SizedBox(height: 4),
            Text(
              reference,
              style: context.textTheme.bodySmall?.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isDark ? primary : const Color(0xFF008080),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ZekrActionButtonsWidget extends ConsumerWidget {
  final String zekrText;
  final String zekrId;
  final String category;

  const ZekrActionButtonsWidget({
    super.key,
    required this.zekrText,
    required this.zekrId,
    required this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primary = context.colorScheme.primary;
    final isFav = ref.watch(isFavoriteProvider(zekrId));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          constraints: const BoxConstraints(),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          icon: Icon(
            isFav ? Icons.star_rounded : Icons.star_border_rounded,
            size: 20,
            color: isFav ? Colors.amber : primary,
          ),
          tooltip: isFav ? "إزالة من المفضلة" : "إضافة للمفضلة",
          onPressed: () async {
            final added = await ref
                .read(FavoritesNotifier.provider.notifier)
                .toggleFavorite(
                  FavoriteItem(
                    id: zekrId,
                    title: category,
                    content: zekrText,
                    extraData: category,
                    type: FavoriteType.zekr,
                    createdAt: DateTime.now(),
                  ),
                );
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(milliseconds: Constants.milliseconds),
                content: Text(
                  added ? "تمت الإضافة للمفضلة ⭐" : "تمت الإزالة من المفضلة",
                ),
              ),
            );
          },
        ),
        IconButton(
          constraints: const BoxConstraints(),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          icon: Icon(Icons.copy_rounded, size: 18, color: primary),
          tooltip: context.l10n.titleCopy,
          onPressed: () async {
            await FlutterClipboard.copy(zekrText);
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(milliseconds: Constants.milliseconds),
                backgroundColor: context.colorScheme.surface,
                content: Text(
                  context.l10n.titleCopy,
                  style: context.textTheme.headlineSmall!.copyWith(
                    color: context.colorScheme.onSurface,
                  ),
                ),
              ),
            );
          },
        ),
        IconButton(
          constraints: const BoxConstraints(),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          icon: Icon(Icons.share_rounded, size: 18, color: primary),
          tooltip: context.l10n.titleShare,
          onPressed: () {
            Share.share(zekrText);
          },
        ),
      ],
    );
  }
}
