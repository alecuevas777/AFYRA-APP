import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';

class FilterChips extends StatelessWidget {
  const FilterChips({
    super.key,
    required this.labels,
    required this.selected,
    required this.onSelected,
  });

  final List<String> labels;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        for (final label in labels)
          ChoiceChip(
              label: Text(label),
              selected: label == selected,
              showCheckmark: false,
              selectedColor: AppColors.blushDeep,
              backgroundColor: AppColors.white,
              labelStyle: textTheme.labelLarge?.copyWith(
                fontWeight: label == selected ? FontWeight.w600 : FontWeight.w500,
              ),
              side: BorderSide(
                color: label == selected ? AppColors.blushDeep : AppColors.line,
              ),
              onSelected: (_) => onSelected(label),
            ),
      ],
    );
  }
}
