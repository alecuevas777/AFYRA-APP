import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/data/mock/purchase_mock.dart';
import 'package:afyra/models/purchase.dart';
import 'package:afyra/widgets/cost_item_tile.dart';
import 'package:afyra/widgets/material_card.dart';
import 'package:afyra/widgets/section_title.dart';

class MaterialsScreen extends StatelessWidget {
  const MaterialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Materiales')),
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
              'Bolsas, stickers y packaging que acompañan cada prenda.',
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.md),
            for (var i = 0; i < materialSupplies.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSpacing.sm),
              MaterialCard(supply: materialSupplies[i]),
            ],
            const SectionTitle('En una prenda'),
            Text(
              'Así se ve el costo de compra más los materiales. Todavía es una lectura de ejemplo.',
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.md),
            _Preview(cost: garmentCosts.first),
          ],
        ),
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({required this.cost});

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
          Text(cost.productName, style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          CostItemTile(label: 'Costo compra', amount: cost.purchaseCost),
          for (final item in cost.associated)
            CostItemTile(label: item.name, amount: item.amount),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Row(
              children: [
                Expanded(child: Text('Costo real', style: textTheme.titleMedium)),
                Text(formatClp(cost.realCost), style: textTheme.titleMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
