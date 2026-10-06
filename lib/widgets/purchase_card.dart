import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/models/purchase.dart';
import 'package:afyra/widgets/purchase_status_badge.dart';

class PurchaseCard extends StatelessWidget {
  const PurchaseCard({super.key, required this.purchase, required this.onTap});

  final Purchase purchase;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cancelled = purchase.status == PurchaseStatus.cancelled;

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '#${purchase.number}',
                      style: textTheme.titleMedium,
                    ),
                  ),
                  PurchaseStatusBadge(status: purchase.status),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                purchase.supplier,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 2),
              Text(mediumDate(purchase.date), style: textTheme.bodySmall),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${purchase.units} unidades',
                      style: textTheme.bodySmall,
                    ),
                  ),
                  Text(
                    formatClp(purchase.total),
                    style: textTheme.titleMedium?.copyWith(
                      color: cancelled ? AppColors.muted : AppColors.ink,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
