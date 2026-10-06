import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/data/mock/product_catalog.dart';
import 'package:afyra/data/mock/product_mock.dart';
import 'package:afyra/widgets/inventory_movement_tile.dart';
import 'package:afyra/widgets/section_title.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Inventario')),
      body: ListenableBuilder(
        listenable: productCatalog,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.xl,
            ),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Stock total', style: textTheme.labelMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${productCatalog.totalUnits}',
                      style: textTheme.headlineMedium,
                    ),
                    Text('unidades en la tienda', style: textTheme.bodySmall),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        Expanded(
                          child: _Count(
                            label: 'Disponibles',
                            value: '${productCatalog.availableCount}',
                          ),
                        ),
                        Expanded(
                          child: _Count(
                            label: 'Stock bajo',
                            value: '${productCatalog.lowCount}',
                          ),
                        ),
                        Expanded(
                          child: _Count(
                            label: 'Agotados',
                            value: '${productCatalog.outCount}',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SectionTitle('Movimientos'),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < mockMovements.length; i++) ...[
                      if (i > 0) const Divider(),
                      InventoryMovementTile(movement: mockMovements[i]),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Count extends StatelessWidget {
  const _Count({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.bodySmall),
        const SizedBox(height: 2),
        Text(value, style: textTheme.titleMedium),
      ],
    );
  }
}
