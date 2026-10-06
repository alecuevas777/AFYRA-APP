import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/models/purchase.dart';
import 'package:afyra/widgets/cost_item_tile.dart';

class CostSummaryCard extends StatelessWidget {
  const CostSummaryCard({super.key, required this.snapshot});

  final MonthCostSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Costos del mes', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Mercadería, materiales y otros gastos del inventario.',
            style: textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          CostItemTile(label: 'Costo de mercadería', amount: snapshot.merchandise),
          CostItemTile(label: 'Materiales', amount: snapshot.materials),
          CostItemTile(label: 'Otros costos', amount: snapshot.other),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Row(
              children: [
                Expanded(child: Text('Costo total', style: textTheme.titleMedium)),
                Text(formatClp(snapshot.total), style: textTheme.titleMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
