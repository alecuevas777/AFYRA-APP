import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/models/customer.dart';
import 'package:afyra/models/sale.dart';
import 'package:afyra/widgets/sale_status_badge.dart';

class CustomerPurchaseItem extends StatelessWidget {
  const CustomerPurchaseItem({super.key, required this.sale, required this.onTap});

  final Sale sale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Venta ${sale.numberLabel}',
                    style: textTheme.titleMedium,
                  ),
                ),
                SaleStatusBadge(status: sale.status),
              ],
            ),
            const SizedBox(height: 2),
            Text(mediumDate(sale.at), style: textTheme.bodySmall),
            const SizedBox(height: AppSpacing.xs),
            Text(
              purchaseNames(sale),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyLarge,
            ),
            Text(sale.piecesLabel, style: textTheme.bodySmall),
            const SizedBox(height: 2),
            Text(formatClp(sale.total), style: textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
