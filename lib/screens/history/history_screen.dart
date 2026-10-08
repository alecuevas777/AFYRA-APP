import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/data/mock/history_catalog.dart';
import 'package:afyra/data/mock/sale_catalog.dart';
import 'package:afyra/models/history_item.dart';
import 'package:afyra/screens/history/inventory_movement_screen.dart';
import 'package:afyra/screens/live/live_finished_screen.dart';
import 'package:afyra/screens/purchases/purchase_detail_screen.dart';
import 'package:afyra/screens/sales/sale_detail_screen.dart';
import 'package:afyra/widgets/filter_chips.dart';
import 'package:afyra/widgets/history_card.dart';
import 'package:afyra/widgets/history_date_group.dart';
import 'package:afyra/widgets/history_range_sheet.dart';
import 'package:afyra/widgets/history_summary.dart';
import 'package:afyra/widgets/search_field.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _search = TextEditingController();
  var _kind = 'Todo';
  var _period = 'Todo';
  DateTime? _from;
  DateTime? _to;

  static const _kinds = ['Todo', 'Ventas', 'Compras', 'Inventario', 'LIVE'];
  static const _periods = ['Hoy', 'Esta semana', 'Este mes', 'Personalizado'];

  @override
  void initState() {
    super.initState();
    _search.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _pickRange() async {
    final range = await showHistoryRangeSheet(context, from: _from, to: _to);
    if (range == null || !mounted) return;
    setState(() {
      _period = 'Personalizado';
      _from = range.from;
      _to = range.to;
    });
  }

  void _open(HistoryItem item) {
    final route = switch (item.kind) {
      HistoryKind.sale => MaterialPageRoute<void>(
        builder: (_) {
          if (item.saleId != null && saleCatalog.find(item.saleId!) != null) {
            return SaleDetailScreen(saleId: item.saleId!);
          }
          return SaleDetailScreen.preview(preview: item.salePreview!);
        },
      ),
      HistoryKind.purchase => MaterialPageRoute<void>(
        builder: (_) => PurchaseDetailScreen(purchaseId: item.purchaseId!),
      ),
      HistoryKind.inventory => MaterialPageRoute<void>(
        builder: (_) => InventoryMovementScreen(item: item),
      ),
      HistoryKind.live => MaterialPageRoute<void>(
        builder: (_) => LiveFinishedScreen(sessionId: item.liveId!),
      ),
    };
    Navigator.of(context).push(route);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(title: const Text('Historial')),
      body: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable: historyCatalog,
          builder: (context, _) {
            final all = historyCatalog.items;
            final visible = all.where((item) {
              return historyMatchesKind(item, _kind) &&
                  historyMatchesQuery(item, _search.text) &&
                  historyMatchesPeriod(
                    item,
                    _period,
                    now,
                    from: _from,
                    to: _to,
                  );
            }).toList();
            final summary = historyDaySummary(all, now);

            return ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              children: [
                Text(
                  'Revisa la actividad de tu negocio.',
                  style: textTheme.bodyLarge,
                ),
                if (all.isEmpty) ...[
                  const _EmptyNote(
                    title: 'Aún no hay actividad',
                    message:
                        'Cuando realices ventas, compras o movimientos aparecerán aquí.',
                  ),
                ] else ...[
                  const SizedBox(height: AppSpacing.lg),
                  HistorySummary(summary: summary),
                  const SizedBox(height: AppSpacing.lg),
                  SearchField(
                    controller: _search,
                    hint: 'Buscar en historial...',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FilterChips(
                    labels: _kinds,
                    selected: _kind,
                    onSelected: (value) => setState(() => _kind = value),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  FilterChips(
                    labels: _periods,
                    selected: _period,
                    onSelected: (value) {
                      if (value == 'Personalizado') {
                        _pickRange();
                        return;
                      }
                      setState(() => _period = _period == value ? 'Todo' : value);
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
                    child: visible.isEmpty
                        ? const _EmptyNote(
                            key: ValueKey('empty-history'),
                            title: 'No encontramos actividad',
                            message: 'Prueba cambiando los filtros o la búsqueda.',
                          )
                        : Column(
                            key: ValueKey('$_kind-$_period-${_search.text}'),
                            children: _groups(visible, now),
                          ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _groups(List<HistoryItem> items, DateTime now) {
    final widgets = <Widget>[];
    String? label;
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final next = historyGroupLabel(item.at, now);
      if (next != label) {
        label = next;
        widgets.add(HistoryDateGroup(label: next));
      }
      final lastOfGroup = i == items.length - 1 ||
          historyGroupLabel(items[i + 1].at, now) != next;
      widgets.add(
        HistoryCard(
          item: item,
          showLine: !lastOfGroup,
          onTap: () => _open(item),
        ),
      );
    }
    return widgets;
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
