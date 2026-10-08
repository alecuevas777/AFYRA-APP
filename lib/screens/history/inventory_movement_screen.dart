import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/models/history_item.dart';

class InventoryMovementScreen extends StatelessWidget {
  const InventoryMovementScreen({super.key, required this.item});

  final HistoryItem item;

  @override
  Widget build(BuildContext context) {
    final movement = item.inventory;
    if (movement == null) {
      return const Scaffold(body: SizedBox.shrink());
    }

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
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
            Text(movement.productName, style: textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(movement.variantLabel, style: textTheme.bodyLarge),
            const SizedBox(height: AppSpacing.lg),
            Text(movement.quantityLabel, style: textTheme.titleLarge),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Column(
                children: [
                  _Row(label: 'Stock anterior', value: '${movement.stockBefore}'),
                  const Divider(height: 1),
                  _Row(label: 'Stock actual', value: '${movement.stockAfter}'),
                  const Divider(height: 1),
                  _Row(label: 'Motivo', value: movement.reason),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              '${mediumDate(item.at)} · ${shortTime(item.at)}',
              style: textTheme.bodySmall,
            ),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          Expanded(child: Text(label, style: textTheme.bodyMedium)),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
