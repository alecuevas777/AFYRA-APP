import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/data/mock/customer_catalog.dart';
import 'package:afyra/data/mock/sale_catalog.dart';
import 'package:afyra/screens/customers/customer_form_screen.dart';
import 'package:afyra/screens/sales/sale_detail_screen.dart';
import 'package:afyra/widgets/customer_avatar.dart';
import 'package:afyra/widgets/customer_contact_actions.dart';
import 'package:afyra/widgets/customer_purchase_item.dart';
import 'package:afyra/widgets/customer_stats.dart';
import 'package:afyra/widgets/section_title.dart';
import 'package:afyra/widgets/soft_entrance.dart';
import 'package:afyra/widgets/status_views.dart';

class CustomerDetailScreen extends StatelessWidget {
  const CustomerDetailScreen({super.key, required this.customerId});

  final String customerId;

  void _preview(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Cliente')),
      body: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable: customerCatalog,
          builder: (context, _) {
            final customer = customerCatalog.find(customerId);
            if (customer == null) {
              return const EmptyView(
                title: 'Cliente no encontrado',
                message: 'Vuelve a la lista e inténtalo de nuevo.',
              );
            }

            final history = customer.history;

            return ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              children: [
                Row(
                  children: [
                    CustomerAvatar(initials: customer.initials, size: 64),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(customer.name, style: textTheme.headlineMedium),
                          const SizedBox(height: 2),
                          Text(customer.phone, style: textTheme.bodyLarge),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                CustomerContactActions(
                  onEdit: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => CustomerFormScreen(customer: customer),
                      ),
                    );
                  },
                  onWhatsapp: () => _preview(
                    context,
                    'WhatsApp se conecta en una etapa posterior.',
                  ),
                  onCall: () => _preview(
                    context,
                    'La llamada se conecta en una etapa posterior.',
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                SoftEntrance(child: CustomerStats(customer: customer)),
                const SizedBox(height: AppSpacing.lg),
                _Line(label: 'WhatsApp', value: customer.whatsapp),
                if (customer.instagram != null)
                  _Line(label: 'Instagram', value: customer.instagram!),
                if (customer.address != null) _Line(label: 'Dirección', value: customer.address!),
                if (customer.notes != null) _Line(label: 'Notas', value: customer.notes!),
                const SectionTitle('Historial de compras'),
                if (history.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    child: Column(
                      children: [
                        Text('Aún no hay compras', style: textTheme.titleMedium),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Este cliente todavía no registra compras.',
                          style: textTheme.bodyMedium?.copyWith(color: AppColors.muted),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Column(
                      children: [
                        for (var i = 0; i < history.length; i++) ...[
                          if (i > 0) const Divider(height: 1),
                          CustomerPurchaseItem(
                            sale: history[i],
                            onTap: () {
                              final sale = history[i];
                              final known = saleCatalog.find(sale.id) != null;
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => known
                                      ? SaleDetailScreen(saleId: sale.id)
                                      : SaleDetailScreen.preview(preview: sale),
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textTheme.bodySmall),
          const SizedBox(height: 2),
          Text(value, style: textTheme.bodyLarge),
        ],
      ),
    );
  }
}
