import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/models/dashboard_data.dart';

class StockRow extends StatelessWidget {
  const StockRow({super.key, required this.item});

  final StockItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final urgent = item.units <= 2;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyLarge,
                ),
                const SizedBox(height: 2),
                Text(item.detail, style: textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '${item.units} u.',
            style: textTheme.labelLarge?.copyWith(
              color: urgent ? AppColors.rose : AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
