import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/models/customer.dart';

class CustomerStats extends StatelessWidget {
  const CustomerStats({super.key, required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    final last = customer.lastPurchaseAt;
    final items = <(String, String)>[
      ('${customer.purchaseCount}', 'Compras'),
      (formatClp(customer.spent), 'Total gastado'),
      (formatClp(customer.averageTicket), 'Ticket promedio'),
      (last == null ? '—' : mediumDate(last), 'Última compra'),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = (constraints.maxWidth - AppSpacing.sm) / 2;
          return Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.md,
            children: [
              for (final item in items)
                SizedBox(
                  width: width,
                  child: _Stat(value: item.$1, label: item.$2),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(value, style: textTheme.titleLarge),
        ),
        const SizedBox(height: 2),
        Text(label, style: textTheme.bodySmall),
      ],
    );
  }
}
