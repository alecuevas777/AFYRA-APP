import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/models/history_item.dart';

class HistorySummary extends StatelessWidget {
  const HistorySummary({super.key, required this.summary});

  final HistoryDaySummary summary;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final line = summary.total == 0
        ? 'Hoy no hay actividad registrada.'
        : '${historyCount(summary.total, 'actividad', 'actividades')} · '
            '${historyCount(summary.sales, 'venta', 'ventas')} · '
            '${historyCount(summary.purchases, 'compra', 'compras')} · '
            '${historyCount(summary.inventory, 'movimiento', 'movimientos')}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hoy', style: textTheme.titleMedium),
          const SizedBox(height: 2),
          Text(line, style: textTheme.bodySmall),
        ],
      ),
    );
  }
}
