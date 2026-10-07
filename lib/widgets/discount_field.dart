import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';

class DiscountField extends StatelessWidget {
  const DiscountField({
    super.key,
    required this.controller,
    required this.percent,
    required this.onPercent,
    required this.amount,
  });

  final TextEditingController controller;
  final bool percent;
  final ValueChanged<bool> onPercent;
  final int amount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            ChoiceChip(
              label: const Text('Monto'),
              selected: !percent,
              showCheckmark: false,
              selectedColor: AppColors.blushDeep,
              backgroundColor: AppColors.white,
              side: BorderSide(color: !percent ? AppColors.blushDeep : AppColors.line),
              onSelected: (_) => onPercent(false),
            ),
            ChoiceChip(
              label: const Text('Porcentaje'),
              selected: percent,
              showCheckmark: false,
              selectedColor: AppColors.blushDeep,
              backgroundColor: AppColors.white,
              side: BorderSide(color: percent ? AppColors.blushDeep : AppColors.line),
              onSelected: (_) => onPercent(true),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          key: const Key('sale-discount'),
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: percent ? 'Porcentaje' : 'Monto',
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          amount == 0 ? 'Sin descuento' : 'Se descuentan ${formatClp(amount)}',
          style: textTheme.bodySmall,
        ),
      ],
    );
  }
}
