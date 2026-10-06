import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/data/mock/product_catalog.dart';
import 'package:afyra/models/product.dart';
import 'package:afyra/screens/inventory/inventory_screen.dart';
import 'package:afyra/screens/products/product_detail_screen.dart';
import 'package:afyra/screens/products/product_form_screen.dart';
import 'package:afyra/widgets/filter_chips.dart';
import 'package:afyra/widgets/product_card.dart';
import 'package:afyra/widgets/search_field.dart';
import 'package:afyra/widgets/status_views.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _search = TextEditingController();
  String _filter = 'Todos';

  static const _filters = ['Todos', 'Disponibles', 'Stock bajo', 'Agotados'];

  @override
  void initState() {
    super.initState();
    _search.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  bool _matches(Product product) {
    final query = _search.text.trim().toLowerCase();
    final textMatches = query.isEmpty ||
        product.name.toLowerCase().contains(query) ||
        product.sku.toLowerCase().contains(query);

    final filterMatches = switch (_filter) {
      'Disponibles' => product.totalStock > 0,
      'Stock bajo' => product.level == StockLevel.low,
      'Agotados' => product.level == StockLevel.out,
      _ => true,
    };

    return textMatches && filterMatches;
  }

  void _openDetail(Product product) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProductDetailScreen(productId: product.id),
      ),
    );
  }

  void _openForm() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ProductFormScreen()),
    );
  }

  void _openInventory() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const InventoryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListenableBuilder(
      listenable: productCatalog,
      builder: (context, _) {
        final visible = productCatalog.products.where(_matches).toList();
        final count = productCatalog.products.length;

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Productos', style: textTheme.titleLarge),
                              const SizedBox(height: 2),
                              Text(
                                '$count prendas',
                                style: textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: _openInventory,
                          child: const Text('Inventario'),
                        ),
                        IconButton(
                          onPressed: _openForm,
                          icon: const Icon(Icons.add),
                          tooltip: 'Agregar producto',
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SearchField(controller: _search),
                    const SizedBox(height: AppSpacing.md),
                    FilterChips(
                      labels: _filters,
                      selected: _filter,
                      onSelected: (label) => setState(() => _filter = label),
                    ),
                  ],
                ),
              ),
            ),
            if (visible.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyView(
                  title: 'Sin prendas',
                  message: 'Ninguna coincide con la búsqueda o el filtro.',
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                sliver: SliverLayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.crossAxisExtent >= 560 ? 3 : 2;
                    return SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        mainAxisSpacing: AppSpacing.md,
                        crossAxisSpacing: AppSpacing.sm,
                        mainAxisExtent: 292,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = visible[index];
                          return ProductCard(
                            product: product,
                            onTap: () => _openDetail(product),
                          );
                        },
                        childCount: visible.length,
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
