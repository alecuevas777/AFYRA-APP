import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';

class SaleSummary extends StatelessWidget {
  const SaleSummary({
    super.key,
    required this.subtotal,
    required this.discount,
    required this.total,
    this.discountNote,
    this.estimatedCost,
    this.estimatedProfit,
  });

  final int subtotal;
  final int discount;
  final int total;
  final String? discountNote;
  final int? estimatedCost;
  final int? estimatedProfit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final note = discountNote == null ? '' : ' · $discountNote';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          _Row(label: 'Subtotal', value: formatClp(subtotal)),
          _Row(label: 'Descuento$note', value: formatClp(-discount)),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Row(
              children: [
                Expanded(child: Text('Total', style: textTheme.titleLarge)),
                Flexible(
                  child: Text(
                    formatClp(total),
                    textAlign: TextAlign.end,
                    style: textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
          if (estimatedCost != null && estimatedProfit != null) ...[
            const Divider(),
            _Row(label: 'Costo estimado', value: formatClp(estimatedCost!)),
            _Row(label: 'Ganancia estimada', value: formatClp(estimatedProfit!)),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(value, style: textTheme.labelLarge),
        ],
      ),
    );
  }
}
