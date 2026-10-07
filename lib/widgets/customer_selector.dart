import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/models/sale.dart';

class CustomerSelector extends StatelessWidget {
  const CustomerSelector({
    super.key,
    required this.customers,
    required this.selectedName,
    required this.onSelected,
  });

  final List<SaleCustomer> customers;
  final String? selectedName;
  final ValueChanged<SaleCustomer?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _Row(
            title: 'Venta sin cliente',
            subtitle: 'Se registra igual, sin asociar un nombre',
            selected: selectedName == null,
            onTap: () => onSelected(null),
          ),
          for (final customer in customers) ...[
            const Divider(height: 1),
            _Row(
              title: customer.name,
              subtitle: customer.phone,
              selected: selectedName == customer.name,
              onTap: () => onSelected(customer),
            ),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: selected ? AppColors.blush : AppColors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: selected ? AppColors.ink : AppColors.line,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
