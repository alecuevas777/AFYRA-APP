import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/models/product.dart';

class VariantGroups extends StatelessWidget {
  const VariantGroups({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final groups = product.variantsByColor.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final group in groups) ...[
          _ColorHeading(colorName: group.key),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final variant in group.value) _SizeStock(variant: variant),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ],
    );
  }
}

class _ColorHeading extends StatelessWidget {
  const _ColorHeading({required this.colorName});

  final String colorName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ColorDot(name: colorName),
        const SizedBox(width: AppSpacing.xs),
        Text(colorName, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}

class _SizeStock extends StatelessWidget {
  const _SizeStock({required this.variant});

  final ProductVariant variant;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final empty = variant.stock <= 0;

    return Container(
      width: 72,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: empty ? AppColors.blush : AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          Text(variant.size, style: textTheme.labelLarge),
          const SizedBox(height: 2),
          Text(
            empty ? '0' : '${variant.stock}',
            style: textTheme.bodySmall?.copyWith(
              color: empty ? AppColors.rose : AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: garmentSwatch(name),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.line),
      ),
    );
  }
}

Color garmentSwatch(String name) {
  return switch (name) {
    'Negro' => AppColors.ink,
    'Blanco' => AppColors.white,
    'Rosa' => AppColors.blushDeep,
    'Azul' => const Color(0xFF3E4654),
    'Beige' => const Color(0xFFE4D2C4),
    _ => AppColors.muted,
  };
}
