import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/models/sale.dart';

class PaymentMethodSelector extends StatelessWidget {
  const PaymentMethodSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final PaymentMethod selected;
  final ValueChanged<PaymentMethod> onSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        for (final method in PaymentMethod.values)
          ChoiceChip(
            label: Text(method.label),
            selected: method == selected,
            showCheckmark: false,
            selectedColor: AppColors.blushDeep,
            backgroundColor: AppColors.white,
            labelStyle: textTheme.labelLarge?.copyWith(
              fontWeight: method == selected ? FontWeight.w600 : FontWeight.w500,
            ),
            side: BorderSide(
              color: method == selected ? AppColors.blushDeep : AppColors.line,
            ),
            onSelected: (_) => onSelected(method),
          ),
      ],
    );
  }
}
