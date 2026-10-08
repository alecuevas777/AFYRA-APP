import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/data/mock/product_catalog.dart';
import 'package:afyra/data/mock/report_mock.dart';
import 'package:afyra/models/report_data.dart';
import 'package:afyra/screens/customers/customer_detail_screen.dart';
import 'package:afyra/screens/live/live_finished_screen.dart';
import 'package:afyra/screens/products/product_detail_screen.dart';
import 'package:afyra/widgets/filter_chips.dart';
import 'package:afyra/widgets/report_metric.dart';
import 'package:afyra/widgets/report_ranking.dart';
import 'package:afyra/widgets/sales_chart.dart';
import 'package:afyra/widgets/section_title.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  var _period = 'Este mes';
  DateTime? _from;
  DateTime? _to;

  static const _periods = [
    'Hoy',
    'Esta semana',
    'Este mes',
    'Últimos 3 meses',
    'Personalizado',
  ];

  Future<void> _pickRange() async {
    final range = await showModalBottomSheet<({DateTime from, DateTime to})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (context) => _RangeSheet(from: _from, to: _to),
    );
    if (range == null || !mounted) return;
    setState(() {
      _period = 'Personalizado';
      _from = range.from;
      _to = range.to;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final report = reportFor(
      _period,
      from: _from,
      to: _to,
      products: productCatalog.products,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Reportes')),
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
            Text('Conoce el rendimiento de tu negocio.', style: textTheme.bodyLarge),
            const SizedBox(height: AppSpacing.lg),
            FilterChips(
              labels: _periods,
              selected: _period,
              onSelected: (value) {
                if (value == 'Personalizado') {
                  _pickRange();
                  return;
                }
                setState(() => _period = value);
              },
            ),
            if (_period == 'Personalizado' && _from != null && _to != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${mediumDate(_from!)} – ${mediumDate(_to!)}',
                style: textTheme.bodySmall,
              ),
            ],
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: report.isEmpty
                  ? const _EmptyNote(
                      key: ValueKey('empty-report'),
                      title: 'No hay datos suficientes',
                      message: 'Cuando registres más actividad podrás ver estadísticas aquí.',
                    )
                  : _Body(key: ValueKey(_period), report: report),
            ),
          ],
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({super.key, required this.report});

  final ReportData report;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Resumen'),
        ReportMetrics(
          sales: report.salesCount,
          revenue: report.revenue,
          profit: report.estimatedProfit,
          units: report.unitsSold,
          salesChange: report.change(report.salesCount, report.previousSales),
          revenueChange: report.change(report.revenue, report.previousRevenue),
          profitChange: report.change(report.estimatedProfit, report.previousProfit),
          unitsChange: report.change(report.unitsSold, report.previousUnits),
        ),
        const SectionTitle('Ventas'),
        SalesChart(bars: report.bars),
        const SectionTitle('Ingresos y ganancia'),
        RevenueSplit(
          revenue: report.revenue,
          cost: report.cost,
          profit: report.estimatedProfit,
        ),
        const SectionTitle('Ticket promedio'),
        TicketCard(
          ticket: report.averageTicket,
          change: report.change(report.averageTicket, report.previousTicket),
        ),
        const SectionTitle('Productos más vendidos'),
        ProductRanking(
          lines: report.ranking,
          onOpen: (line) => _openProduct(context, line.productId),
        ),
        const SectionTitle('Mejor margen'),
        MarginList(
          lines: report.bestMargins,
          onOpen: (line) => _openProduct(context, line.productId),
        ),
        const SectionTitle('Ventas por categoría'),
        CategoryBars(shares: report.categories),
        const SectionTitle('Clientes frecuentes'),
        CustomerRanking(
          customers: report.customers,
          onOpen: (customer) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => CustomerDetailScreen(customerId: customer.customerId),
              ),
            );
          },
        ),
        const SectionTitle('Rendimiento de LIVE'),
        LivePerformanceList(
          lives: report.lives,
          headline: liveHeadline(report.lives),
          onOpen: (live) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => LiveFinishedScreen(sessionId: live.sessionId),
              ),
            );
          },
        ),
        const SectionTitle('Stock a revisar'),
        StockAlerts(
          lowStock: report.lowStock,
          noSales: report.noSales,
          onOpen: (note) => _openProduct(context, note.productId),
        ),
        if (report.insights.isNotEmpty) ...[
          const SectionTitle('Insights'),
          InsightList(insights: report.insights),
        ],
      ],
    );
  }

  void _openProduct(BuildContext context, String productId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => ProductDetailScreen(productId: productId)),
    );
  }
}

class _EmptyNote extends StatelessWidget {
  const _EmptyNote({super.key, required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Column(
        children: [
          Text(title, style: textTheme.titleMedium, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            style: textTheme.bodyMedium?.copyWith(color: AppColors.muted),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _RangeSheet extends StatefulWidget {
  const _RangeSheet({this.from, this.to});

  final DateTime? from;
  final DateTime? to;

  @override
  State<_RangeSheet> createState() => _RangeSheetState();
}

class _RangeSheetState extends State<_RangeSheet> {
  DateTime? _from;
  DateTime? _to;

  @override
  void initState() {
    super.initState();
    _from = widget.from;
    _to = widget.to;
  }

  Future<void> _pick({required bool start}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (start ? _from : _to) ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      helpText: start ? 'Fecha inicial' : 'Fecha final',
      cancelText: 'Cancelar',
      confirmText: 'Elegir',
    );
    if (picked == null) return;
    setState(() {
      if (start) {
        _from = picked;
      } else {
        _to = picked;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final ready = _from != null && _to != null;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Personalizado', style: textTheme.titleLarge),
            const SizedBox(height: AppSpacing.lg),
            _DateButton(
              label: 'Fecha inicial',
              value: _from == null ? 'Elegir fecha' : mediumDate(_from!),
              onTap: () => _pick(start: true),
            ),
            const SizedBox(height: AppSpacing.sm),
            _DateButton(
              label: 'Fecha final',
              value: _to == null ? 'Elegir fecha' : mediumDate(_to!),
              onTap: () => _pick(start: false),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: ready
                    ? () => Navigator.of(context).pop((from: _from!, to: _to!))
                    : null,
                child: const Text('Aplicar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  const _DateButton({required this.label, required this.value, required this.onTap});

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: textTheme.bodySmall),
                    Text(value, style: textTheme.bodyLarge),
                  ],
                ),
              ),
              const Icon(Icons.calendar_today_outlined, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
