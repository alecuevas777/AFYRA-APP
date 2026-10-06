import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/data/mock/product_catalog.dart';
import 'package:afyra/data/mock/product_mock.dart';
import 'package:afyra/models/product.dart';
import 'package:afyra/widgets/product_image.dart';
import 'package:afyra/widgets/section_title.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key, this.product});

  final Product? product;

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _VariantDraft {
  _VariantDraft({required this.color, required this.size, int stock = 0})
    : stock = TextEditingController(text: '$stock');

  final String color;
  final String size;
  final TextEditingController stock;

  void dispose() => stock.dispose();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  late final TextEditingController _name;
  late final TextEditingController _sku;
  late final TextEditingController _description;
  late final TextEditingController _cost;
  late final TextEditingController _price;
  late String _category;
  late final List<_VariantDraft> _variants;
  String? _error;

  bool get _editing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _name = TextEditingController(text: product?.name ?? '');
    _sku = TextEditingController(text: product?.sku ?? '');
    _description = TextEditingController(text: product?.description ?? '');
    _cost = TextEditingController(text: product == null ? '' : '${product.cost}');
    _price = TextEditingController(text: product == null ? '' : '${product.price}');
    _category = product?.category ?? productCategories.first;
    _variants = [
      for (final variant in product?.variants ?? _newProductVariants())
        _VariantDraft(
          color: variant.color,
          size: variant.size,
          stock: variant.stock,
        ),
    ];
    for (final controller in [_cost, _price]) {
      controller.addListener(() => setState(() {}));
    }
  }

  List<ProductVariant> _newProductVariants() {
    return const [
      ProductVariant(color: 'Negro', size: 'S', stock: 0),
      ProductVariant(color: 'Negro', size: 'M', stock: 0),
      ProductVariant(color: 'Negro', size: 'L', stock: 0),
      ProductVariant(color: 'Blanco', size: 'S', stock: 0),
      ProductVariant(color: 'Blanco', size: 'M', stock: 0),
      ProductVariant(color: 'Blanco', size: 'L', stock: 0),
    ];
  }

  @override
  void dispose() {
    _name.dispose();
    _sku.dispose();
    _description.dispose();
    _cost.dispose();
    _price.dispose();
    for (final variant in _variants) {
      variant.dispose();
    }
    super.dispose();
  }

  int _money(String raw) {
    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
  }

  void _save() {
    final name = _name.text.trim();
    final price = _money(_price.text);
    if (name.isEmpty) {
      setState(() => _error = 'Escribe el nombre de la prenda.');
      return;
    }
    if (price <= 0) {
      setState(() => _error = 'El precio de venta tiene que ser mayor a cero.');
      return;
    }

    final product = Product(
      id: widget.product?.id ?? 'local-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      category: _category,
      sku: _sku.text.trim().isEmpty ? 'SIN-SKU' : _sku.text.trim(),
      description: _description.text.trim(),
      cost: _money(_cost.text),
      price: price,
      variants: [
        for (final draft in _variants)
          ProductVariant(
            color: draft.color,
            size: draft.size,
            stock: _money(draft.stock.text),
          ),
      ],
    );
    productCatalog.upsert(product);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            _editing
                ? 'Cambios listos en esta sesión.'
                : 'Prenda agregada en esta sesión.',
          ),
        ),
      );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final margin = _money(_price.text) - _money(_cost.text);
    final groups = <String, List<_VariantDraft>>{};
    for (final variant in _variants) {
      groups.putIfAbsent(variant.color, () => []).add(variant);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_editing ? 'Editar producto' : 'Nuevo producto'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        children: [
          const ProductImage(height: 180, iconSize: 40),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'La foto se conectará más adelante con el almacenamiento.',
                    ),
                  ),
                );
              },
              child: const Text('Agregar foto'),
            ),
          ),
          _Field(
            label: 'Nombre',
            controller: _name,
            fieldKey: const Key('product-name'),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Categoría', style: textTheme.bodySmall),
          const SizedBox(height: AppSpacing.xs),
          DropdownButtonFormField<String>(
            initialValue: _category,
            items: [
              for (final category in productCategories)
                DropdownMenuItem(value: category, child: Text(category)),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() => _category = value);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          _Field(label: 'SKU', controller: _sku),
          const SizedBox(height: AppSpacing.md),
          _Field(label: 'Descripción', controller: _description, maxLines: 3),
          const SizedBox(height: AppSpacing.md),
          _Field(
            label: 'Costo',
            controller: _cost,
            keyboard: TextInputType.number,
          ),
          const SizedBox(height: AppSpacing.md),
          _Field(
            label: 'Precio de venta',
            controller: _price,
            keyboard: TextInputType.number,
            fieldKey: const Key('product-price'),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('Margen ${formatClp(margin)}', style: textTheme.bodySmall),
          const SectionTitle('Variantes'),
          Text(
            'Cada color agrupa sus tallas. El stock de abajo es de la variante, no del producto completo.',
            style: textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          for (final entry in groups.entries) ...[
            Text(entry.key, style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            for (final draft in entry.value) ...[
              Row(
                children: [
                  SizedBox(width: 36, child: Text(draft.size, style: textTheme.labelLarge)),
                  Expanded(
                    child: TextField(
                      controller: draft.stock,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(hintText: 'Stock'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            const SizedBox(height: AppSpacing.sm),
          ],
          OutlinedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Sumar un color nuevo queda preparado para más adelante.',
                  ),
                ),
              );
            },
            child: const Text('Otro color'),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.xs,
            AppSpacing.lg,
            AppSpacing.sm,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_error != null) ...[
                Text(
                  _error!,
                  style: textTheme.bodyMedium?.copyWith(color: AppColors.rose),
                ),
                const SizedBox(height: AppSpacing.xs),
              ],
              FilledButton(onPressed: _save, child: const Text('Guardar')),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    this.keyboard,
    this.maxLines = 1,
    this.fieldKey,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboard;
  final int maxLines;
  final Key? fieldKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          key: fieldKey,
          controller: controller,
          keyboardType: keyboard,
          maxLines: maxLines,
          inputFormatters: keyboard == TextInputType.number
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,
          decoration: InputDecoration(hintText: label),
        ),
      ],
    );
  }
}
