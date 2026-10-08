import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/models/report_data.dart';

class SalesChart extends StatelessWidget {
  const SalesChart({super.key, required this.bars});

  final List<ReportBar> bars;

  @override
  Widget build(BuildContext context) {
    if (bars.isEmpty) return const SizedBox.shrink();
    final textTheme = Theme.of(context).textTheme;
    final peak = bars.fold<int>(0, (max, bar) => bar.amount > max ? bar.amount : max);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: SizedBox(
        height: 148,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (final bar in bars)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          formatClpCompact(bar.amount),
                          maxLines: 1,
                          style: textTheme.labelSmall,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: FractionallySizedBox(
                            heightFactor: peak == 0 ? 0 : (bar.amount / peak).clamp(0.08, 1),
                            widthFactor: 1,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: AppColors.blushDeep,
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(bar.label, style: textTheme.labelMedium),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class RevenueSplit extends StatelessWidget {
  const RevenueSplit({
    super.key,
    required this.revenue,
    required this.cost,
    required this.profit,
  });

  final int revenue;
  final int cost;
  final int profit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final costShare = revenue == 0 ? 0.0 : cost / revenue;

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
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: SizedBox(
              height: 12,
              child: Row(
                children: [
                  Expanded(
                    flex: (costShare * 1000).round().clamp(1, 999),
                    child: const ColoredBox(color: AppColors.blushDeep),
                  ),
                  Expanded(
                    flex: (1000 - (costShare * 1000).round()).clamp(1, 999),
                    child: const ColoredBox(color: AppColors.ink),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _Line(label: 'Ingresos', value: formatClp(revenue), color: AppColors.ink),
          _Line(label: 'Costos', value: formatClp(cost), color: AppColors.blushDeep),
          _Line(label: 'Ganancia estimada', value: formatClp(profit), color: AppColors.ink),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'La ganancia es ingresos menos costos estimados.',
            style: textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(label, style: textTheme.bodyMedium)),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryBars extends StatelessWidget {
  const CategoryBars({super.key, required this.shares});

  final List<CategoryShare> shares;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          for (final share in shares) ...[
            Row(
              children: [
                Expanded(child: Text(share.name, style: textTheme.bodyLarge)),
                Text('${share.percent}%', style: textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: LinearProgressIndicator(
                value: share.percent / 100,
                minHeight: 8,
                backgroundColor: AppColors.blush,
                color: AppColors.blushDeep,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}
