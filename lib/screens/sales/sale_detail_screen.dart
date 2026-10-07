import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/data/mock/sale_catalog.dart';
import 'package:afyra/models/sale.dart';
import 'package:afyra/widgets/sale_item_tile.dart';
import 'package:afyra/widgets/sale_status_badge.dart';
import 'package:afyra/widgets/sale_summary.dart';
import 'package:afyra/widgets/section_title.dart';
import 'package:afyra/widgets/status_views.dart';

class SaleDetailScreen extends StatelessWidget {
  const SaleDetailScreen({super.key, required this.saleId}) : preview = null;

  const SaleDetailScreen.preview({super.key, required this.preview}) : saleId = '';

  final String saleId;
  final Sale? preview;

  @override
  Widget build(BuildContext context) {
    if (preview != null) return _SaleBody(sale: preview!);

    return ListenableBuilder(
      listenable: saleCatalog,
      builder: (context, _) {
        final sale = saleCatalog.find(saleId);
        if (sale == null) {
          return const Scaffold(
            body: EmptyView(
              title: 'Venta no encontrada',
              message: 'Vuelve al historial e inténtalo de nuevo.',
            ),
          );
        }

        return _SaleBody(sale: sale);
      },
    );
  }
}

class _SaleBody extends StatelessWidget {
  const _SaleBody({required this.sale});

  final Sale sale;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
          appBar: AppBar(title: Text('Venta ${sale.numberLabel}')),
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
                Text(sale.customerLabel, style: textTheme.titleLarge),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${mediumDate(sale.at)} · ${shortTime(sale.at)}',
                  style: textTheme.bodySmall,
                ),
                if (sale.customerPhone != null) ...[
                  const SizedBox(height: 2),
                  Text(sale.customerPhone!, style: textTheme.bodySmall),
                ],
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SaleStatusBadge(status: sale.status),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(sale.payment.label, style: textTheme.bodyLarge),
                const SectionTitle('Prendas'),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: Column(
                    children: [
                      for (var i = 0; i < sale.lines.length; i++) ...[
                        if (i > 0) const Divider(),
                        SaleItemTile(line: sale.lines[i]),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                SaleSummary(
                  subtotal: sale.subtotal,
                  discount: sale.discount,
                  total: sale.total,
                  discountNote: sale.discountNote,
                  estimatedCost: sale.estimatedCost,
                  estimatedProfit: sale.estimatedProfit,
                ),
              ],
            ),
          ),
    );
  }
}
