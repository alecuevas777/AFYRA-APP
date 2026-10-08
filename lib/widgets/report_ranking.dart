import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/models/report_data.dart';
import 'package:afyra/widgets/product_image.dart';

class ProductRanking extends StatelessWidget {
  const ProductRanking({super.key, required this.lines, required this.onOpen});

  final List<ReportLine> lines;
  final ValueChanged<ReportLine> onOpen;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      children: [
        for (var i = 0; i < lines.length; i++) ...[
          if (i > 0) const Divider(height: 1),
          _ProductRow(position: i + 1, line: lines[i], onTap: () => onOpen(lines[i])),
        ],
      ],
    );
  }
}

class _ProductRow extends StatelessWidget {
  const _ProductRow({required this.position, required this.line, required this.onTap});

  final int position;
  final ReportLine line;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final sold = line.units == 1 ? '1 vendido' : '${line.units} vendidos';

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  position.toString().padLeft(2, '0'),
                  style: textTheme.bodySmall,
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: const SizedBox(
                width: 44,
                child: ProductImage(height: 44, iconSize: 18),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(line.name, style: textTheme.bodyLarge),
                  const SizedBox(height: 2),
                  Text('$sold · ${formatClp(line.revenue)}', style: textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MarginList extends StatelessWidget {
  const MarginList({super.key, required this.lines, required this.onOpen});

  final List<ReportLine> lines;
  final ValueChanged<ReportLine> onOpen;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      children: [
        for (var i = 0; i < lines.length; i++) ...[
          if (i > 0) const Divider(height: 1),
          _MarginRow(line: lines[i], onTap: () => onOpen(lines[i])),
        ],
      ],
    );
  }
}

class _MarginRow extends StatelessWidget {
  const _MarginRow({required this.line, required this.onTap});

  final ReportLine line;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final percent = formatPercent(line.marginPercent).replaceFirst('+', '');

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(line.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: textTheme.bodyLarge),
                  const SizedBox(height: 2),
                  Text(
                    'Costo ${formatClp(line.unitCost)} · Venta ${formatClp(line.unitPrice)}',
                    style: textTheme.bodySmall,
                  ),
                  Text('Margen ${formatClp(line.unitMargin)}', style: textTheme.bodySmall),
                ],
              ),
            ),
            Text(percent, style: textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}

class CustomerRanking extends StatelessWidget {
  const CustomerRanking({
    super.key,
    required this.customers,
    required this.onOpen,
  });

  final List<ReportCustomerStat> customers;
  final ValueChanged<ReportCustomerStat> onOpen;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      children: [
        for (var i = 0; i < customers.length; i++) ...[
          if (i > 0) const Divider(height: 1),
          _CustomerRow(customer: customers[i], onTap: () => onOpen(customers[i])),
        ],
      ],
    );
  }
}

class _CustomerRow extends StatelessWidget {
  const _CustomerRow({required this.customer, required this.onTap});

  final ReportCustomerStat customer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final purchases = customer.purchases == 1 ? '1 compra' : '${customer.purchases} compras';

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(customer.name, style: textTheme.bodyLarge),
                  Text(
                    '$purchases · ${relativeDay(customer.lastPurchase)}',
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Text(formatClp(customer.spent), style: textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}

class LivePerformanceList extends StatelessWidget {
  const LivePerformanceList({
    super.key,
    required this.lives,
    required this.headline,
    required this.onOpen,
  });

  final List<ReportLiveStat> lives;
  final String? headline;
  final ValueChanged<ReportLiveStat> onOpen;

  @override
  Widget build(BuildContext context) {
    if (lives.isEmpty) {
      return Text(
        'Sin LIVE finalizados en este período.',
        style: Theme.of(context).textTheme.bodySmall,
      );
    }
    final peak = lives.fold<int>(0, (max, live) => live.income > max ? live.income : max);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (headline != null) ...[
          Text(headline!, style: textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.sm),
        ],
        _Panel(
          children: [
            for (var i = 0; i < lives.length; i++) ...[
              if (i > 0) const Divider(height: 1),
              _LiveRow(
                live: lives[i],
                share: peak == 0 ? 0 : lives[i].income / peak,
                onTap: () => onOpen(lives[i]),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _LiveRow extends StatelessWidget {
  const _LiveRow({required this.live, required this.share, required this.onTap});

  final ReportLiveStat live;
  final double share;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(live.name, style: textTheme.bodyLarge)),
                Text(formatClp(live.income), style: textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              '${live.sales} ventas · ${live.units} productos · ${formatClp(live.profit)} ganancia',
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.xs),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: LinearProgressIndicator(
                value: share,
                minHeight: 6,
                backgroundColor: AppColors.blush,
                color: AppColors.blushDeep,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StockAlerts extends StatelessWidget {
  const StockAlerts({
    super.key,
    required this.lowStock,
    required this.noSales,
    required this.onOpen,
  });

  final List<StockNote> lowStock;
  final List<StockNote> noSales;
  final ValueChanged<StockNote> onOpen;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final outOfStock = lowStock.where((note) => note.detail == 'Sin stock').toList();
    final low = lowStock.where((note) => note.detail != 'Sin stock').toList();

    return _Panel(
      children: [
        if (low.isNotEmpty) ...[
          Text('Bajo stock', style: textTheme.labelMedium),
          for (final note in low) _Note(note: note, onTap: () => onOpen(note)),
        ],
        if (outOfStock.isNotEmpty) ...[
          if (low.isNotEmpty) const SizedBox(height: AppSpacing.sm),
          Text('Sin stock', style: textTheme.labelMedium),
          for (final note in outOfStock) _Note(note: note, onTap: () => onOpen(note)),
        ],
        if (noSales.isNotEmpty) ...[
          if (low.isNotEmpty || outOfStock.isNotEmpty) const SizedBox(height: AppSpacing.sm),
          Text('Sin ventas recientes', style: textTheme.labelMedium),
          for (final note in noSales) _Note(note: note, onTap: () => onOpen(note)),
        ],
      ],
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.note, required this.onTap});

  final StockNote note;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(note.name, style: textTheme.bodyLarge),
            Text(note.detail, style: textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class InsightList extends StatelessWidget {
  const InsightList({super.key, required this.insights});

  final List<String> insights;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.blush,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < insights.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.sm),
            Text(insights[i], style: textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}

class TicketCard extends StatelessWidget {
  const TicketCard({super.key, required this.ticket, required this.change});

  final int ticket;
  final double? change;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(formatClp(ticket), style: textTheme.titleLarge),
          const SizedBox(height: 2),
          Text('Promedio gastado por venta', style: textTheme.bodySmall),
          ReportDeltaSlot(change: change),
        ],
      ),
    );
  }
}

class ReportDeltaSlot extends StatelessWidget {
  const ReportDeltaSlot({super.key, required this.change});

  final double? change;

  @override
  Widget build(BuildContext context) {
    if (change == null) return const SizedBox.shrink();
    final quiet = change!.abs() < 0.05;
    final color = quiet
        ? AppColors.muted
        : change! > 0
        ? AppColors.ink
        : AppColors.rose;
    final label = quiet ? 'Sin cambios' : '${formatPercent(change!)} vs período anterior';
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color)),
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
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}
