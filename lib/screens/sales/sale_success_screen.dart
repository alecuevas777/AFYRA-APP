import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/data/mock/sale_catalog.dart';
import 'package:afyra/screens/sales/sale_detail_screen.dart';
import 'package:afyra/screens/sales/sale_form_screen.dart';
import 'package:afyra/widgets/status_views.dart';

class SaleSuccessScreen extends StatelessWidget {
  const SaleSuccessScreen({super.key, required this.saleId});

  final String saleId;

  @override
  Widget build(BuildContext context) {
    final sale = saleCatalog.find(saleId);
    if (sale == null) {
      return const Scaffold(
        body: EmptyView(
          title: 'Venta no encontrada',
          message: 'Vuelve al historial e inténtalo de nuevo.',
        ),
      );
    }

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Venta')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.blush,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 28),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Venta registrada', style: textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(formatClp(sale.total), style: textTheme.titleLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(sale.customerLabel, style: textTheme.bodyLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(sale.payment.label, style: textTheme.bodySmall),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => SaleDetailScreen(saleId: sale.id),
                      ),
                    );
                  },
                  child: const Text('Ver venta'),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (_) => const SaleFormScreen(),
                      ),
                    );
                  },
                  child: const Text('Nueva venta'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
