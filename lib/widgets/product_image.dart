import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';

/// Lugar de la foto. Más adelante la imagen vendrá de Supabase Storage.
class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    this.height = 148,
    this.borderRadius,
    this.iconSize = 32,
  });

  final double height;
  final BorderRadius? borderRadius;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.blush,
        borderRadius: borderRadius,
      ),
      child: Icon(
        Icons.checkroom_outlined,
        size: iconSize,
        color: AppColors.ink.withValues(alpha: 0.72),
      ),
    );
  }
}
