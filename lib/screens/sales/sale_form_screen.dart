import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/data/mock/product_catalog.dart';
import 'package:afyra/data/mock/sale_catalog.dart';
import 'package:afyra/data/mock/sale_mock.dart';
import 'package:afyra/models/sale.dart';
import 'package:afyra/screens/sales/sale_success_screen.dart';
import 'package:afyra/widgets/cart_line_tile.dart';
import 'package:afyra/widgets/customer_selector.dart';
import 'package:afyra/widgets/discount_field.dart';
import 'package:afyra/widgets/payment_method_selector.dart';
import 'package:afyra/widgets/product_variant_picker.dart';
import 'package:afyra/widgets/sale_summary.dart';
import 'package:afyra/widgets/section_title.dart';

class SaleFormScreen extends StatefulWidget {
  const SaleFormScreen({super.key});

  @override
  State<SaleFormScreen> createState() => _SaleFormScreenState();
}

class _SaleFormScreenState extends State<SaleFormScreen> {
  final _discount = TextEditingController();
  final _lines = <SaleLine>[];
  late String _product;
  late String _variant;
  int _quantity = 1;
  bool _percent = false;
  bool _editing = false;
  SaleCustomer? _customer;
  PaymentMethod _payment = PaymentMethod.transfer;
  String? _error;

  @override
  void initState() {
    super.initState();
    final products = productCatalog.products;
    _product = products.isEmpty ? '' : products.first.name;
    _variant = _firstVariant(_product);
    _discount.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _discount.dispose();
    super.dispose();
  }

  String _firstVariant(String productName) {
    for (final product in productCatalog.products) {
      if (product.name != productName || product.variants.isEmpty) continue;
      return variantLabelOf(product.variants.first);
    }
    return '';
  }

  int get _subtotal => _lines.fold(0, (sum, line) => sum + line.subtotal);

  int get _estimatedCost =>
      _lines.fold(0, (sum, line) => sum + line.estimatedCost);

  int get _discountAmount {
    final raw = int.tryParse(_discount.text.trim()) ?? 0;
    return discountAmount(subtotal: _subtotal, raw: raw, percent: _percent);
  }

  int get _total => _subtotal - _discountAmount;

  void _addLine() {
    final matches = productCatalog.products.where((item) => item.name == _product);
    if (matches.isEmpty || _variant.isEmpty || _quantity <= 0) {
      setState(() => _error = 'Elige una prenda y una variante.');
      return;
    }
    final match = matches.first;
    final cost = estimatedUnitCost(match.name, match.cost);
    final index = _lines.indexWhere(
      (line) => line.productName == _product && line.variantLabel == _variant,
    );
    setState(() {
      _error = null;
      if (index >= 0) {
        _lines[index] = _lines[index].copyWith(
          quantity: _lines[index].quantity + _quantity,
        );
      } else {
        _lines.add(
          SaleLine(
            productName: match.name,
            variantLabel: _variant,
            quantity: _quantity,
            unitPrice: match.price,
            estimatedUnitCost: cost,
          ),
        );
      }
      _quantity = 1;
      _editing = false;
    });
  }

  void _confirm() {
    if (_lines.isEmpty) {
      setState(() => _error = 'Agrega al menos una prenda.');
      return;
    }

    final number = saleCatalog.nextNumber;
    final now = DateTime.now();
    final sale = Sale(
      id: 'local-$number',
      number: number,
      customerName: _customer?.name,
      customerPhone: _customer?.phone,
      at: now,
      status: SaleStatus.completed,
      payment: _payment,
      lines: List<SaleLine>.from(_lines),
      discount: _discountAmount,
      discountNote: _percent && _discountAmount > 0 ? '${_discount.text.trim()}%' : null,
    );
    saleCatalog.add(sale);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => SaleSuccessScreen(saleId: sale.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva venta')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        children: [
          Text(
            _editing ? 'Cambiar prenda' : 'Agregar prendas',
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Elige la prenda, la variante y cuántas salen.',
            style: textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          ProductVariantPicker(
            products: productCatalog.products,
            productName: _product,
            variantLabel: _variant,
            quantity: _quantity,
            addLabel: _editing ? 'Actualizar' : 'Agregar',
            onProduct: (name) {
              setState(() {
                _product = name;
                _variant = _firstVariant(name);
              });
            },
            onVariant: (value) => setState(() => _variant = value),
            onQuantity: (value) => setState(() => _quantity = value),
            onAdd: _addLine,
          ),
          const SectionTitle('Venta'),
          if (_lines.isEmpty)
            Text(
              'Todavía no hay prendas en esta venta.',
              style: textTheme.bodySmall,
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Column(
                children: [
                  for (var i = 0; i < _lines.length; i++) ...[
                    if (i > 0) const Divider(),
                    CartLineTile(
                      line: _lines[i],
                      onAdd: () => setState(() {
                        _lines[i] = _lines[i].copyWith(quantity: _lines[i].quantity + 1);
                      }),
                      onRemove: () => setState(() {
                        if (_lines[i].quantity <= 1) {
                          _lines.removeAt(i);
                        } else {
                          _lines[i] = _lines[i].copyWith(
                            quantity: _lines[i].quantity - 1,
                          );
                        }
                      }),
                      onDelete: () => setState(() => _lines.removeAt(i)),
                      onEdit: () {
                        final line = _lines[i];
                        setState(() {
                          _product = line.productName;
                          _variant = line.variantLabel;
                          _quantity = line.quantity;
                          _editing = true;
                          _lines.removeAt(i);
                        });
                      },
                    ),
                  ],
                ],
              ),
            ),
          const SectionTitle('Descuento'),
          DiscountField(
            controller: _discount,
            percent: _percent,
            amount: _discountAmount,
            onPercent: (value) => setState(() => _percent = value),
          ),
          const SectionTitle('Cliente'),
          CustomerSelector(
            customers: saleCustomers,
            selectedName: _customer?.name,
            onSelected: (customer) => setState(() => _customer = customer),
          ),
          const SectionTitle('Pago'),
          PaymentMethodSelector(
            selected: _payment,
            onSelected: (method) => setState(() => _payment = method),
          ),
          const SizedBox(height: AppSpacing.lg),
          SaleSummary(
            subtotal: _subtotal,
            discount: _discountAmount,
            total: _total,
            discountNote: _percent && _discountAmount > 0
                ? '${_discount.text.trim()}%'
                : null,
            estimatedCost: _estimatedCost,
            estimatedProfit: _total - _estimatedCost,
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
              Text('Total ${formatClp(_total)}', style: textTheme.titleMedium),
              if (_error != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _error!,
                  style: textTheme.bodyMedium?.copyWith(color: AppColors.rose),
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              FilledButton(
                key: const Key('confirm-sale'),
                onPressed: _confirm,
                child: const Text('Confirmar venta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
