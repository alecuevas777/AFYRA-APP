import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/models/sale.dart';

class SaleItemTile extends StatelessWidget {
  const SaleItemTile({super.key, required this.line});

  final SaleLine line;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.productName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyLarge,
                ),
                const SizedBox(height: 2),
                Text(line.variantLabel, style: textTheme.bodySmall),
                const SizedBox(height: 2),
                Text(
                  '${line.quantity} × ${formatClp(line.unitPrice)}',
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(formatClp(line.subtotal), style: textTheme.labelLarge),
        ],
      ),
    );
  }
}
