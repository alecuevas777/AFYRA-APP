import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/data/mock/sale_catalog.dart';
import 'package:afyra/data/mock/sale_mock.dart';
import 'package:afyra/models/sale.dart';
import 'package:afyra/screens/sales/sale_detail_screen.dart';
import 'package:afyra/screens/sales/sale_form_screen.dart';
import 'package:afyra/widgets/filter_chips.dart';
import 'package:afyra/widgets/sale_card.dart';
import 'package:afyra/widgets/search_field.dart';
import 'package:afyra/widgets/section_title.dart';
import 'package:afyra/widgets/status_views.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final _search = TextEditingController();
  String _filter = 'Todas';

  static const _filters = ['Todas', 'Hoy', 'Esta semana', 'Este mes'];

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

  List<Sale> _visible(List<Sale> all) {
    final now = DateTime.now();
    final query = _search.text;
    final matched = all.where((sale) {
      return saleMatchesQuery(sale, query) && saleMatchesFilter(sale, _filter, now);
    }).toList();
    matched.sort((a, b) => b.at.compareTo(a.at));
    return matched;
  }

  void _openDetail(Sale sale) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SaleDetailScreen(saleId: sale.id),
      ),
    );
  }

  void _openForm() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const SaleFormScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListenableBuilder(
      listenable: saleCatalog,
      builder: (context, _) {
        final visible = _visible(saleCatalog.sales);

        return ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ventas', style: textTheme.titleLarge),
                      const SizedBox(height: 2),
                      Text('Del mostrador', style: textTheme.bodySmall),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Nueva venta',
                  onPressed: _openForm,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
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
                  Text('Ventas de hoy', style: textTheme.labelMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    formatClp(saleCatalog.todayIncome),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: _Stat(
                          label: 'Ventas',
                          value: '${saleCatalog.todayCount}',
                        ),
                      ),
                      Expanded(
                        child: _Stat(
                          label: 'Ganancia estimada',
                          value: formatClp(saleCatalog.todayProfit),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SearchField(
              controller: _search,
              hint: 'Buscar cliente o número',
            ),
            const SizedBox(height: AppSpacing.md),
            FilterChips(
              labels: _filters,
              selected: _filter,
              onSelected: (label) => setState(() => _filter = label),
            ),
            const SectionTitle('Ventas recientes'),
            if (visible.isEmpty)
              const SizedBox(
                height: 220,
                child: EmptyView(
                  title: 'Sin ventas',
                  message: 'Ninguna coincide con la búsqueda o el filtro.',
                ),
              )
            else
              for (var i = 0; i < visible.length; i++) ...[
                if (i > 0) const SizedBox(height: AppSpacing.sm),
                SaleCard(
                  key: ValueKey('sale-${visible[i].number}'),
                  sale: visible[i],
                  onTap: () => _openDetail(visible[i]),
                ),
              ],
          ],
        );
      },
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
