import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/models/sale.dart';

class SaleStatusBadge extends StatelessWidget {
  const SaleStatusBadge({super.key, required this.status});

  final SaleStatus status;

  @override
  Widget build(BuildContext context) {
    final label = switch (status) {
      SaleStatus.completed => 'Completada',
      SaleStatus.pending => 'Pendiente',
      SaleStatus.cancelled => 'Cancelada',
    };
    final color = switch (status) {
      SaleStatus.completed => AppColors.ink,
      SaleStatus.pending => AppColors.muted,
      SaleStatus.cancelled => AppColors.rose,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: status == SaleStatus.pending ? AppColors.white : AppColors.blush,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: status == SaleStatus.pending ? AppColors.line : AppColors.blush,
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color),
      ),
    );
  }
}
