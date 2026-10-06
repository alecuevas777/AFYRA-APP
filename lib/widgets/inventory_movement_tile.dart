import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/models/product.dart';

class InventoryMovementTile extends StatelessWidget {
  const InventoryMovementTile({super.key, required this.movement});

  final StockMovement movement;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final incoming = movement.quantity > 0;
    final amount = incoming ? '+${movement.quantity}' : '${movement.quantity}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 42,
            child: Text(
              amount,
              style: textTheme.titleMedium?.copyWith(
                color: incoming ? AppColors.ink : AppColors.rose,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movement.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyLarge,
                ),
                const SizedBox(height: 2),
                Text(
                  '${movement.variantLabel} · ${movement.when}',
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(movement.type, style: textTheme.labelMedium),
        ],
      ),
    );
  }
}
