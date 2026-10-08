import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';

class ReportDelta extends StatelessWidget {
  const ReportDelta({super.key, required this.change});

  final double? change;

  @override
  Widget build(BuildContext context) {
    if (change == null) return const SizedBox.shrink();
    final quiet = change!.abs() < 0.05;
    final color = quiet
        ? AppColors.muted
        : change! > 0
        ? AppColors.ink
        : AppColors.rose;
    final label = quiet ? 'Sin cambios' : formatPercent(change!);

    return Text(
      label,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
    );
  }
}

class ReportMetrics extends StatelessWidget {
  const ReportMetrics({
    super.key,
    required this.sales,
    required this.revenue,
    required this.profit,
    required this.units,
    required this.salesChange,
    required this.revenueChange,
    required this.profitChange,
    required this.unitsChange,
  });

  final int sales;
  final int revenue;
  final int profit;
  final int units;
  final double? salesChange;
  final double? revenueChange;
  final double? profitChange;
  final double? unitsChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _Metric(label: 'Ventas', value: '$sales', change: salesChange)),
              Expanded(
                child: _Metric(label: 'Ingresos', value: formatClp(revenue), change: revenueChange),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  label: 'Ganancia estimada',
                  value: formatClp(profit),
                  change: profitChange,
                ),
              ),
              Expanded(
                child: _Metric(
                  label: 'Productos vendidos',
                  value: '$units',
                  change: unitsChange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, required this.change});

  final String label;
  final String value;
  final double? change;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.bodySmall),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(value, maxLines: 1, style: textTheme.titleMedium),
        ),
        ReportDelta(change: change),
      ],
    );
  }
}
