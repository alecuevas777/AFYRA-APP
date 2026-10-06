import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/data/mock/product_catalog.dart';
import 'package:afyra/screens/products/product_form_screen.dart';
import 'package:afyra/widgets/product_image.dart';
import 'package:afyra/widgets/section_title.dart';
import 'package:afyra/widgets/status_views.dart';
import 'package:afyra/widgets/stock_badge.dart';
import 'package:afyra/widgets/variant_groups.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: productCatalog,
      builder: (context, _) {
        final product = productCatalog.find(productId);
        if (product == null) {
          return const Scaffold(
            body: EmptyView(
              title: 'Prenda no encontrada',
              message: 'Vuelve al catálogo e inténtalo de nuevo.',
            ),
          );
        }

        final textTheme = Theme.of(context).textTheme;

        return Scaffold(
          appBar: AppBar(
            title: Text(product.category),
            actions: [
              IconButton(
                tooltip: 'Editar',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ProductFormScreen(product: product),
                    ),
                  );
                },
                icon: const Icon(Icons.edit_outlined),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.only(bottom: AppSpacing.xl),
            children: [
              const ProductImage(height: 280, iconSize: 48),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: textTheme.headlineMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(formatClp(product.price), style: textTheme.titleLarge),
                    const SizedBox(height: AppSpacing.lg),
                    _Facts(productId: product.id),
                    const SectionTitle('Variantes'),
                    Text(
                      'El producto agrupa colores y tallas. Cada talla tiene su propio stock.',
                      style: textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    VariantGroups(product: product),
                    const SectionTitle('Descripción'),
                    Text(product.description, style: textTheme.bodyLarge),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Facts extends StatelessWidget {
  const _Facts({required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    final product = productCatalog.find(productId)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          _Fact(label: 'Costo', value: formatClp(product.cost)),
          const Divider(),
          _Fact(label: 'Margen', value: formatClp(product.margin)),
          const Divider(),
          _Fact(
            label: 'Stock',
            value: '${product.totalStock}',
            trailing: StockBadge(product: product),
          ),
          const Divider(),
          _Fact(label: 'SKU', value: product.sku),
          const Divider(),
          _Fact(label: 'Categoría', value: product.category),
        ],
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value, this.trailing});

  final String label;
  final String value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(child: Text(label, style: textTheme.bodySmall)),
          Flexible(
            child: trailing ??
                Text(
                  value,
                  textAlign: TextAlign.end,
                  style: textTheme.labelLarge,
                ),
          ),
        ],
      ),
    );
  }
}
