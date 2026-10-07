import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/models/sale.dart';

class CartLineTile extends StatelessWidget {
  const CartLineTile({
    super.key,
    required this.line,
    required this.onAdd,
    required this.onRemove,
    required this.onDelete,
    required this.onEdit,
  });

  final SaleLine line;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            line.productName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 2),
          Text(line.variantLabel, style: textTheme.bodySmall),
          const SizedBox(height: 2),
          Text(
            'Costo ${formatClp(line.estimatedUnitCost)} · Margen ${formatClp(line.estimatedMargin)}',
            style: textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              IconButton(
                tooltip: 'Bajar cantidad',
                onPressed: onRemove,
                icon: const Icon(Icons.remove),
              ),
              Text('${line.quantity}', style: textTheme.titleMedium),
              IconButton(
                tooltip: 'Subir cantidad',
                onPressed: onAdd,
                icon: const Icon(Icons.add),
              ),
              const Spacer(),
              Text(formatClp(line.subtotal), style: textTheme.labelLarge),
            ],
          ),
          Row(
            children: [
              TextButton(onPressed: onEdit, child: const Text('Cambiar')),
              TextButton(
                onPressed: onDelete,
                child: Text(
                  'Quitar',
                  style: textTheme.labelLarge?.copyWith(color: AppColors.rose),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
