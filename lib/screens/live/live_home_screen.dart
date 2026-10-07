import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/theme/app_typography.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/data/mock/live_catalog.dart';
import 'package:afyra/data/mock/product_catalog.dart';
import 'package:afyra/models/live_session.dart';
import 'package:afyra/models/product.dart';
import 'package:afyra/screens/live/live_finished_screen.dart';
import 'package:afyra/screens/live/live_start_screen.dart';
import 'package:afyra/widgets/end_live_dialog.dart';
import 'package:afyra/widgets/live_product_card.dart';
import 'package:afyra/widgets/live_sale_item.dart';
import 'package:afyra/widgets/live_stats.dart';
import 'package:afyra/widgets/live_status_badge.dart';
import 'package:afyra/widgets/quick_sale_sheet.dart';
import 'package:afyra/widgets/search_field.dart';
import 'package:afyra/widgets/section_title.dart';

class LiveHomeScreen extends StatelessWidget {
  const LiveHomeScreen({super.key});

  Future<void> _finish(BuildContext context) async {
    final confirmed = await confirmEndLive(context);
    if (!confirmed || !context.mounted) return;
    final session = liveCatalog.finish();
    if (session == null || !context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => LiveFinishedScreen(sessionId: session.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: liveCatalog,
      builder: (context, _) {
        final session = liveCatalog.active;
        if (session == null) return const _Lobby();
        return _ActivePanel(
          session: session,
          onFinish: () => _finish(context),
        );
      },
    );
  }
}

class _Lobby extends StatelessWidget {
  const _Lobby();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final history = liveCatalog.history;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      children: [
        const Text(
          'Live',
          style: TextStyle(
            fontFamily: AppTypography.accentFamily,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
            fontSize: 40,
            height: 0.9,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Un panel corto para vender mientras transmites.',
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.xl),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.blushDeep,
              foregroundColor: AppColors.ink,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const LiveStartScreen()),
              );
            },
            key: const Key('lobby-start'),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Dot(),
                SizedBox(width: AppSpacing.xs),
                Text('Iniciar LIVE'),
              ],
            ),
          ),
        ),
        const SectionTitle('Anteriores'),
        for (final session in history)
          _HistoryCard(
            session: session,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => LiveFinishedScreen(sessionId: session.id),
                ),
              );
            },
          ),
      ],
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.session, required this.onTap});

  final LiveSession session;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(session.name, style: textTheme.titleMedium),
                    ),
                    const LiveStatusBadge(status: LiveStatus.finished),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(mediumDate(session.startedAt), style: textTheme.bodySmall),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '${session.salesCount} ventas · ${formatClp(session.income)}',
                  style: textTheme.bodyLarge,
                ),
                Text(
                  '${formatClp(session.profit)} ganancia · ${formatDuration(session.elapsed)}',
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActivePanel extends StatefulWidget {
  const _ActivePanel({required this.session, required this.onFinish});

  final LiveSession session;
  final VoidCallback onFinish;

  @override
  State<_ActivePanel> createState() => _ActivePanelState();
}

class _ActivePanelState extends State<_ActivePanel> {
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _search.addListener(_onSearch);
  }

  void _onSearch() => setState(() {});

  @override
  void dispose() {
    _search.removeListener(_onSearch);
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _search.text.trim().toLowerCase();
    final products = productCatalog.products.where((product) {
      if (query.isEmpty) return true;
      return product.name.toLowerCase().contains(query) ||
          product.sku.toLowerCase().contains(query);
    }).toList()
      ..sort((a, b) {
        final aStock = _hasStock(a) ? 0 : 1;
        final bStock = _hasStock(b) ? 0 : 1;
        return aStock.compareTo(bStock);
      });

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.sm,
          ),
          child: Column(
            children: [
              LiveHeader(session: widget.session, onFinish: widget.onFinish),
              const SizedBox(height: AppSpacing.sm),
              LiveStats(session: widget.session),
              Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                    ),
                    onPressed: () => _showRecent(context),
                    child: const Text('Últimas ventas'),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                    ),
                    onPressed: () => _showSummary(context),
                    child: const Text('Resumen'),
                  ),
                ],
              ),
              SearchField(controller: _search, hint: 'Buscar producto'),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.xl,
            ),
            children: [
              for (final product in products)
                LiveProductCard(
                  product: product,
                  session: widget.session,
                  onSell: () => openQuickSale(context, product),
                ),
            ],
          ),
        ),
      ],
    );
  }

  bool _hasStock(Product product) {
    return product.variants.any(
      (variant) =>
          widget.session.stockOf(product.id, variant.color, variant.size) > 0,
    );
  }

  void _showRecent(BuildContext context) {
    final sales = widget.session.visibleSales;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (context) {
        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Text('Últimas ventas', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              if (sales.isEmpty)
                Text(
                  'Todavía no hay ventas en este LIVE.',
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              else
                for (final sale in sales) ...[
                  LiveSaleItem(sale: sale),
                  const Divider(height: 1),
                ],
            ],
          ),
        );
      },
    );
  }

  void _showSummary(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (context) {
        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Text('Resumen', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              LiveStats(session: widget.session, detailed: true),
              const SizedBox(height: AppSpacing.lg),
              Text('Más vendidos', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              LiveRanking(session: widget.session),
            ],
          ),
        );
      },
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: AppColors.ink,
        shape: BoxShape.circle,
      ),
    );
  }
}
