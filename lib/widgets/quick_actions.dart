import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key, required this.onAction});

  final ValueChanged<String> onAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _QuietAction(label: 'Producto', onPressed: onAction)),
            const SizedBox(width: AppSpacing.xs),
            Expanded(child: _QuietAction(label: 'Compra', onPressed: onAction)),
            const SizedBox(width: AppSpacing.xs),
            Expanded(child: _QuietAction(label: 'Venta', onPressed: onAction)),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.blushDeep,
              foregroundColor: AppColors.ink,
            ),
            onPressed: () => onAction('LIVE'),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LiveDot(),
                SizedBox(width: AppSpacing.xs),
                Text('Iniciar LIVE'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuietAction extends StatelessWidget {
  const _QuietAction({required this.label, required this.onPressed});

  final String label;
  final ValueChanged<String> onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => onPressed(label),
      child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}

class _LiveDot extends StatelessWidget {
  const _LiveDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: AppColors.ink,
        shape: BoxShape.circle,
      ),
    );
  }
}
