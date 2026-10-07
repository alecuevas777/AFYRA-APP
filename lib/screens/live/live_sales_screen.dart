import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/data/mock/live_catalog.dart';
import 'package:afyra/widgets/live_sale_item.dart';
import 'package:afyra/widgets/status_views.dart';

class LiveSalesScreen extends StatelessWidget {
  const LiveSalesScreen({super.key, required this.sessionId});

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

    final sales = session.visibleSales;

    return Scaffold(
      appBar: AppBar(title: Text(session.name)),
      body: sales.isEmpty
          ? const EmptyView(
              title: 'Sin ventas',
              message: 'Este LIVE todavía no tiene ventas registradas.',
            )
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                for (final sale in sales) ...[
                  LiveSaleItem(sale: sale),
                  const Divider(height: 1),
                ],
              ],
            ),
    );
  }
}
