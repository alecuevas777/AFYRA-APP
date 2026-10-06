import 'package:flutter/material.dart';

import 'package:afyra/core/constants/app_constants.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/theme/app_typography.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/data/mock/dashboard_mock.dart';
import 'package:afyra/models/dashboard_data.dart';
import 'package:afyra/widgets/live_summary.dart';
import 'package:afyra/widgets/quick_actions.dart';
import 'package:afyra/widgets/sale_row.dart';
import 'package:afyra/widgets/section_title.dart';
import 'package:afyra/widgets/soft_entrance.dart';
import 'package:afyra/widgets/soft_panel.dart';
import 'package:afyra/widgets/stock_row.dart';
import 'package:afyra/widgets/summary_block.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    this.data = dashboardMock,
    this.now,
    required this.onAction,
  });

  final DashboardData data;
  final DateTime? now;
  final ValueChanged<String> onAction;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final moment = now ?? DateTime.now();

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      children: [
        const Text('Hola', style: AppTypography.accent),
        const SizedBox(height: AppSpacing.xs),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                AppConstants.userName,
                style: textTheme.titleLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(shortDate(moment), style: textTheme.bodySmall),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        SoftEntrance(
          child: SummaryBlock(
            income: data.income,
            profit: data.profit,
            salesCount: data.salesCount,
            productsSold: data.productsSold,
          ),
        ),
        const SectionTitle('Acciones'),
        QuickActions(onAction: onAction),
        const SectionTitle('Tu inventario'),
        SoftEntrance(
          delay: const Duration(milliseconds: 70),
          child: SoftPanel(
            child: Column(
              children: [
                for (var i = 0; i < data.lowStock.length; i++) ...[
                  if (i > 0) const Divider(),
                  StockRow(item: data.lowStock[i]),
                ],
              ],
            ),
          ),
        ),
        const SectionTitle('Últimas ventas'),
        SoftEntrance(
          delay: const Duration(milliseconds: 120),
          child: SoftPanel(
            child: Column(
              children: [
                for (var i = 0; i < data.recentSales.length; i++) ...[
                  if (i > 0) const Divider(),
                  SaleRow(sale: data.recentSales[i]),
                ],
              ],
            ),
          ),
        ),
        const SectionTitle('Último LIVE'),
        SoftEntrance(
          delay: const Duration(milliseconds: 170),
          child: LiveSummary(live: data.lastLive),
        ),
      ],
    );
  }
}
