import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/models/product.dart';
import 'package:afyra/widgets/product_image.dart';
import 'package:afyra/widgets/stock_badge.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.onTap});

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProductImage(height: 132),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sm,
                AppSpacing.sm,
                AppSpacing.sm,
                AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium,
                  ),
                  if (product.mainColor.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(product.mainColor, style: textTheme.bodySmall),
                  ],
                  const SizedBox(height: AppSpacing.xs),
                  Text(formatClp(product.price), style: textTheme.bodyLarge),
                  const SizedBox(height: 2),
                  StockBadge(product: product),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
