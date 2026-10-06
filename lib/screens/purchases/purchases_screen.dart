import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/data/mock/purchase_catalog.dart';
import 'package:afyra/data/mock/purchase_mock.dart';
import 'package:afyra/models/purchase.dart';
import 'package:afyra/screens/purchases/materials_screen.dart';
import 'package:afyra/screens/purchases/purchase_detail_screen.dart';
import 'package:afyra/screens/purchases/purchase_form_screen.dart';
import 'package:afyra/screens/purchases/real_cost_screen.dart';
import 'package:afyra/widgets/cost_summary_card.dart';
import 'package:afyra/widgets/filter_chips.dart';
import 'package:afyra/widgets/purchase_card.dart';
import 'package:afyra/widgets/section_title.dart';
import 'package:afyra/widgets/status_views.dart';

class PurchasesScreen extends StatefulWidget {
  const PurchasesScreen({super.key});

  @override
  State<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  String _filter = 'Todas';

  static const _filters = ['Todas', 'Este mes', 'Último mes', 'Mayor costo'];

  List<Purchase> _visible(List<Purchase> all) {
    final now = DateTime.now();
    final previous = DateTime(now.year, now.month - 1);
    final filtered = switch (_filter) {
      'Este mes' => all.where(
        (purchase) =>
            purchase.date.year == now.year && purchase.date.month == now.month,
      ),
      'Último mes' => all.where(
        (purchase) =>
            purchase.date.year == previous.year &&
            purchase.date.month == previous.month,
      ),
      _ => all,
    }.toList();

    if (_filter == 'Mayor costo') {
      filtered.sort((a, b) => b.total.compareTo(a.total));
    } else {
      filtered.sort((a, b) {
        final byDate = b.date.compareTo(a.date);
        if (byDate != 0) return byDate;
        return b.number.compareTo(a.number);
      });
    }
    return filtered;
  }

  void _openDetail(Purchase purchase) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PurchaseDetailScreen(purchaseId: purchase.id),
      ),
    );
  }

  void _openForm() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const PurchaseFormScreen()),
    );
  }

  void _openMaterials() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const MaterialsScreen()),
    );
  }

  void _openRealCost() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const RealCostScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compras'),
        actions: [
          IconButton(
            tooltip: 'Nueva compra',
            onPressed: _openForm,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable: purchaseCatalog,
          builder: (context, _) {
            final visible = _visible(purchaseCatalog.purchases);
            final latest = purchaseCatalog.latest;

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
                      Text('Total comprado', style: textTheme.labelMedium),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        formatClp(purchaseCatalog.completedTotal),
                        style: textTheme.headlineMedium,
                      ),
                      Text('compras completadas', style: textTheme.bodySmall),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        children: [
                          Expanded(
                            child: _Stat(
                              label: 'Del mes',
                              value: '${purchaseCatalog.monthCount}',
                            ),
                          ),
                          Expanded(
                            child: _Stat(
                              label: 'Unidades',
                              value: '${purchaseCatalog.acquiredUnits}',
                            ),
                          ),
                          Expanded(
                            child: _Stat(
                              label: 'Última',
                              value: latest == null ? '—' : '#${latest.number}',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                const CostSummaryCard(snapshot: monthCostSnapshot),
                Wrap(
                  spacing: AppSpacing.xs,
                  children: [
                    TextButton(
                      onPressed: _openMaterials,
                      child: const Text('Materiales'),
                    ),
                    TextButton(
                      onPressed: _openRealCost,
                      child: const Text('Costo real'),
                    ),
                  ],
                ),
                const SectionTitle('Historial'),
                FilterChips(
                  labels: _filters,
                  selected: _filter,
                  onSelected: (label) => setState(() => _filter = label),
                ),
                const SizedBox(height: AppSpacing.md),
                if (visible.isEmpty)
                  const SizedBox(
                    height: 240,
                    child: EmptyView(
                      title: 'Sin compras',
                      message: 'Ninguna coincide con este filtro.',
                    ),
                  )
                else
                  for (var i = 0; i < visible.length; i++) ...[
                    if (i > 0) const SizedBox(height: AppSpacing.sm),
                    PurchaseCard(
                      key: ValueKey('purchase-${visible[i].number}'),
                      purchase: visible[i],
                      onTap: () => _openDetail(visible[i]),
                    ),
                  ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

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
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleMedium,
        ),
      ],
    );
  }
}
