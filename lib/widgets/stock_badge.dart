import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/models/product.dart';

class StockBadge extends StatelessWidget {
  const StockBadge({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final out = product.level == StockLevel.out;
    final low = product.level == StockLevel.low;
    final label = out ? 'Sin stock' : '${product.totalStock} uds';

    return Text(
      label,
      style: textTheme.labelMedium?.copyWith(
        color: out || low ? AppColors.rose : null,
      ),
    );
  }
}
