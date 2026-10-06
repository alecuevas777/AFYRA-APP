import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/theme/app_typography.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/models/dashboard_data.dart';
import 'package:afyra/widgets/app_badge.dart';

class LiveSummary extends StatelessWidget {
  const LiveSummary({super.key, required this.live});

  final LiveSnapshot live;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.blush,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Live',
                style: TextStyle(
                  fontFamily: AppTypography.accentFamily,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                  fontSize: 32,
                  height: 1,
                  color: AppColors.ink,
                ),
              ),
              const Spacer(),
              AppBadge(label: live.status),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(live.when, style: textTheme.bodySmall),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.sm,
            children: [
              _LiveStat(label: 'Ventas', value: '${live.sales}'),
              _LiveStat(label: 'Ingresos', value: formatClp(live.income)),
              _LiveStat(label: 'Prendas', value: '${live.productsSold}'),
            ],
          ),
        ],
      ),
    );
  }
}

class _LiveStat extends StatelessWidget {
  const _LiveStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.bodySmall?.copyWith(color: AppColors.dark)),
        const SizedBox(height: 2),
        Text(value, style: textTheme.titleMedium),
      ],
    );
  }
}
