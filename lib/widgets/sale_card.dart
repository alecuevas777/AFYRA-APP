import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/models/sale.dart';
import 'package:afyra/widgets/sale_status_badge.dart';

class SaleCard extends StatelessWidget {
  const SaleCard({super.key, required this.sale, required this.onTap});

  final Sale sale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cancelled = sale.status == SaleStatus.cancelled;

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
                      sale.customerLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  SaleStatusBadge(status: sale.status),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${sale.piecesLabel} · ${sale.numberLabel}',
                style: textTheme.bodySmall,
              ),
              const SizedBox(height: 2),
              Text(shortTime(sale.at), style: textTheme.bodySmall),
              const SizedBox(height: AppSpacing.md),
              Text(
                formatClp(sale.total),
                style: textTheme.titleMedium?.copyWith(
                  color: cancelled ? AppColors.muted : AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
