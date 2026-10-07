import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/data/mock/live_catalog.dart';
import 'package:afyra/screens/live/live_sales_screen.dart';
import 'package:afyra/screens/live/live_start_screen.dart';
import 'package:afyra/widgets/live_stats.dart';
import 'package:afyra/widgets/status_views.dart';

class LiveFinishedScreen extends StatelessWidget {
  const LiveFinishedScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context) {
    final session = liveCatalog.find(sessionId);
    if (session == null) {
      return const Scaffold(
        body: EmptyView(
          title: 'LIVE no encontrado',
          message: 'Vuelve al panel e inténtalo de nuevo.',
        ),
      );
    }

    final textTheme = Theme.of(context).textTheme;
    final featured = session.featuredName;

    return Scaffold(
      appBar: AppBar(title: const Text('LIVE finalizado')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(session.name, style: textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${mediumDate(session.startedAt)} · ${formatDuration(session.elapsed)}',
            style: textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.lg),
          LiveStats(session: session, detailed: true),
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.blush,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Producto más vendido', style: textTheme.bodySmall),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  featured.isEmpty ? 'Sin ventas todavía' : featured,
                  style: textTheme.titleLarge,
                ),
                if (featured.isNotEmpty)
                  Text(
                    '${session.featuredUnits} ${session.featuredUnits == 1 ? 'unidad' : 'unidades'}',
                    style: textTheme.bodyLarge,
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Más vendidos', style: textTheme.titleMedium),
          LiveRanking(session: session),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => LiveSalesScreen(sessionId: session.id),
                      ),
                    );
                  },
                  child: const Text('Ver ventas'),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: liveCatalog.active != null
                      ? null
                      : () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute<void>(
                              builder: (_) => const LiveStartScreen(),
                            ),
                          );
                        },
                  child: const Text('Nuevo LIVE'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
