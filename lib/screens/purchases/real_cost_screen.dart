import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/data/mock/purchase_mock.dart';
import 'package:afyra/models/purchase.dart';
import 'package:afyra/widgets/cost_item_tile.dart';

class RealCostScreen extends StatelessWidget {
  const RealCostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Costo real')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          children: [
            Text(
              'El costo de la prenda más lo que usas para entregarla.',
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.md),
            for (var i = 0; i < garmentCosts.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSpacing.md),
              _GarmentCostCard(cost: garmentCosts[i]),
            ],
          ],
        ),
      ),
    );
  }
}

class _GarmentCostCard extends StatelessWidget {
  const _GarmentCostCard({required this.cost});

  final GarmentCost cost;

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
          Text(cost.productName, style: textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          CostItemTile(label: 'Costo compra', amount: cost.purchaseCost),
          for (final item in cost.associated)
            CostItemTile(label: item.name, amount: item.amount),
          const Divider(),
          _Amount(label: 'Costo real', amount: cost.realCost, strong: true),
          _Amount(label: 'Precio venta', amount: cost.salePrice),
          _Amount(label: 'Margen', amount: cost.margin, strong: true),
        ],
      ),
    );
  }
}

class _Amount extends StatelessWidget {
  const _Amount({
    required this.label,
    required this.amount,
    this.strong = false,
  });

  final String label;
  final int amount;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final style = strong ? textTheme.titleMedium : textTheme.bodyLarge;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(formatClp(amount), style: style),
        ],
      ),
    );
  }
}
