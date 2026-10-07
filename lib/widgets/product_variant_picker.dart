import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/models/product.dart';

class ProductVariantPicker extends StatelessWidget {
  const ProductVariantPicker({
    super.key,
    required this.products,
    required this.productName,
    required this.variantLabel,
    required this.quantity,
    required this.onProduct,
    required this.onVariant,
    required this.onQuantity,
    required this.onAdd,
    this.addLabel = 'Agregar',
  });

  final List<Product> products;
  final String productName;
  final String variantLabel;
  final int quantity;
  final ValueChanged<String> onProduct;
  final ValueChanged<String> onVariant;
  final ValueChanged<int> onQuantity;
  final VoidCallback onAdd;
  final String addLabel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final product = _selected(products, productName);
    final variants = product == null
        ? const <String>[]
        : [for (final variant in product.variants) variantLabelOf(variant)];
    final currentVariant = variants.contains(variantLabel)
        ? variantLabel
        : (variants.isEmpty ? '' : variants.first);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Producto', style: textTheme.bodySmall),
        const SizedBox(height: AppSpacing.xs),
        DropdownButtonFormField<String>(
          key: ValueKey('sale-product-$productName'),
          initialValue: product?.name,
          isExpanded: true,
          items: [
            for (final item in products)
              DropdownMenuItem(value: item.name, child: Text(item.name)),
          ],
          onChanged: (value) {
            if (value != null) onProduct(value);
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        Text('Variante', style: textTheme.bodySmall),
        const SizedBox(height: AppSpacing.xs),
        DropdownButtonFormField<String>(
          key: ValueKey('sale-variant-$productName-$currentVariant'),
          initialValue: currentVariant.isEmpty ? null : currentVariant,
          isExpanded: true,
          items: [
            for (final variant in variants)
              DropdownMenuItem(value: variant, child: Text(variant)),
          ],
          onChanged: (value) {
            if (value != null) onVariant(value);
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        Text('Cantidad', style: textTheme.bodySmall),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            _Step(
              tooltip: 'Restar cantidad',
              icon: Icons.remove,
              onPressed: quantity > 1 ? () => onQuantity(quantity - 1) : null,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text('$quantity', style: textTheme.titleMedium),
            ),
            _Step(
              tooltip: 'Sumar cantidad',
              icon: Icons.add,
              onPressed: () => onQuantity(quantity + 1),
            ),
            const Spacer(),
            if (product != null)
              Text(formatClp(product.price), style: textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton(
          key: const Key('add-sale-line'),
          onPressed: products.isEmpty ? null : onAdd,
          child: Text(addLabel),
        ),
      ],
    );
  }
}

String variantLabelOf(ProductVariant variant) {
  return '${variant.color} / ${variant.size}';
}

Product? _selected(List<Product> products, String name) {
  for (final product in products) {
    if (product.name == name) return product;
  }
  return products.isEmpty ? null : products.first;
}

class _Step extends StatelessWidget {
  const _Step({required this.tooltip, required this.icon, required this.onPressed});

  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }
}
