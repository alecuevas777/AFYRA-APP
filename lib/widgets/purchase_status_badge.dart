import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/models/purchase.dart';

class PurchaseStatusBadge extends StatelessWidget {
  const PurchaseStatusBadge({super.key, required this.status});

  final PurchaseStatus status;

  @override
  Widget build(BuildContext context) {
    final label = switch (status) {
      PurchaseStatus.completed => 'Completada',
      PurchaseStatus.pending => 'Pendiente',
      PurchaseStatus.cancelled => 'Cancelada',
    };
    final color = switch (status) {
      PurchaseStatus.completed => AppColors.ink,
      PurchaseStatus.pending => AppColors.muted,
      PurchaseStatus.cancelled => AppColors.rose,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: status == PurchaseStatus.pending ? AppColors.white : AppColors.blush,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: status == PurchaseStatus.pending ? AppColors.line : AppColors.blush,
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color),
      ),
    );
  }
}
