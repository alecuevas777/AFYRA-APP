import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/models/customer.dart';
import 'package:afyra/widgets/customer_avatar.dart';

class CustomerCard extends StatelessWidget {
  const CustomerCard({super.key, required this.customer, required this.onTap});

  final Customer customer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final last = customer.lastPurchaseAt;
    final purchases = customer.purchaseCount == 1
        ? '1 compra'
        : '${customer.purchaseCount} compras';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                CustomerAvatar(initials: customer.initials),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              customer.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.titleMedium,
                            ),
                          ),
                          if (customer.frequent) ...[
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              'Frecuente',
                              style: textTheme.labelMedium?.copyWith(color: AppColors.rose),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(customer.phone, style: textTheme.bodySmall),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '$purchases · ${formatClp(customer.spent)}',
                        style: textTheme.bodyLarge,
                      ),
                      Text(
                        last == null
                            ? 'Sin compras todavía'
                            : 'Última compra · ${relativeDay(last)}',
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
