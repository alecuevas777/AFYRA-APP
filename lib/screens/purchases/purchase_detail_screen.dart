import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/data/mock/purchase_catalog.dart';
import 'package:afyra/widgets/cost_item_tile.dart';
import 'package:afyra/widgets/purchase_item_tile.dart';
import 'package:afyra/widgets/purchase_status_badge.dart';
import 'package:afyra/widgets/section_title.dart';
import 'package:afyra/widgets/status_views.dart';

class PurchaseDetailScreen extends StatelessWidget {
  const PurchaseDetailScreen({super.key, required this.purchaseId});

  final String purchaseId;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: purchaseCatalog,
      builder: (context, _) {
        final purchase = purchaseCatalog.find(purchaseId);
        if (purchase == null) {
          return const Scaffold(
            body: EmptyView(
              title: 'Compra no encontrada',
              message: 'Vuelve al historial e inténtalo de nuevo.',
            ),
          );
        }

        final textTheme = Theme.of(context).textTheme;

        return Scaffold(
          appBar: AppBar(title: Text('Compra #${purchase.number}')),
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
                Text(purchase.supplier, style: textTheme.titleLarge),
                const SizedBox(height: AppSpacing.xs),
                Text(mediumDate(purchase.date), style: textTheme.bodySmall),
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: Alignment.centerLeft,
                  child: PurchaseStatusBadge(status: purchase.status),
                ),
                const SectionTitle('Prendas'),
                _Panel(
                  children: [
                    for (var i = 0; i < purchase.lines.length; i++) ...[
                      if (i > 0) const Divider(),
                      PurchaseItemTile(line: purchase.lines[i]),
                    ],
                  ],
                ),
                const SectionTitle('Costos adicionales'),
                if (purchase.extras.isEmpty)
                  Text('Esta compra no suma otros costos.', style: textTheme.bodySmall)
                else
                  _Panel(
                    children: [
                      for (var i = 0; i < purchase.extras.length; i++) ...[
                        if (i > 0) const Divider(),
                        CostItemTile(
                          label: purchase.extras[i].name,
                          amount: purchase.extras[i].amount,
                        ),
                      ],
                    ],
                  ),
                const SizedBox(height: AppSpacing.lg),
                _Panel(
                  children: [
                    CostItemTile(label: 'Subtotal', amount: purchase.merchandise),
                    const Divider(),
                    CostItemTile(
                      label: 'Costos adicionales',
                      amount: purchase.extrasTotal,
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      child: Row(
                        children: [
                          Expanded(child: Text('Total', style: textTheme.titleLarge)),
                          Flexible(
                            child: Text(
                              formatClp(purchase.total),
                              textAlign: TextAlign.end,
                              style: textTheme.titleLarge,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(children: children),
    );
  }
}
