import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/models/live_session.dart';
import 'package:afyra/models/product.dart';
import 'package:afyra/widgets/product_image.dart';

class LiveProductCard extends StatelessWidget {
  const LiveProductCard({
    super.key,
    required this.product,
    required this.session,
    required this.onSell,
  });

  final Product product;
  final LiveSession session;
  final VoidCallback onSell;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final variant = _shownVariant(product, session);
    final stock = variant == null
        ? 0
        : session.stockOf(product.id, variant.color, variant.size);
    final level = liveStockLevel(stock);
    final stockColor = level == LiveStockLevel.ok ? AppColors.ink : AppColors.rose;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: [
              SizedBox(
                width: 72,
                child: ProductImage(
                  height: 88,
                  iconSize: 22,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium,
                    ),
                    if (variant != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        '${variant.color} / ${variant.size}',
                        style: textTheme.bodySmall,
                      ),
                    ],
                    const SizedBox(height: 4),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      layoutBuilder: (currentChild, _) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: currentChild,
                        );
                      },
                      child: Text(
                        liveStockLabel(stock),
                        key: ValueKey(stock),
                        style: textTheme.labelLarge?.copyWith(color: stockColor),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(formatClp(product.price), style: textTheme.bodyLarge),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              if (stock > 0)
                FilledButton(
                  key: ValueKey('live-sell-${product.id}'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.blushDeep,
                    foregroundColor: AppColors.ink,
                    minimumSize: const Size(104, 48),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: onSell,
                  child: const Text('Vender'),
                )
              else
                Text('Agotado', style: textTheme.labelLarge?.copyWith(color: AppColors.rose)),
            ],
          ),
        ),
      ),
    );
  }
}

ProductVariant? shownLiveVariant(Product product, LiveSession session) {
  return _shownVariant(product, session);
}

ProductVariant? _shownVariant(Product product, LiveSession session) {
  ProductVariant? best;
  var bestStock = -1;
  for (final variant in product.variants) {
    final stock = session.stockOf(product.id, variant.color, variant.size);
    if (stock > bestStock) {
      best = variant;
      bestStock = stock;
    }
  }
  return best;
}
