import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/data/mock/purchase_catalog.dart';
import 'package:afyra/data/mock/purchase_mock.dart';
import 'package:afyra/models/purchase.dart';
import 'package:afyra/widgets/section_title.dart';
import 'package:afyra/widgets/supplier_selector.dart';

class _LineDraft {
  _LineDraft({
    required this.product,
    required this.variant,
    required String quantity,
    required String unitCost,
  }) : quantity = TextEditingController(text: quantity),
       unitCost = TextEditingController(text: unitCost);

  String product;
  String variant;
  final TextEditingController quantity;
  final TextEditingController unitCost;

  void dispose() {
    quantity.dispose();
    unitCost.dispose();
  }
}

class _CostDraft {
  _CostDraft({required String name, required String amount})
    : name = TextEditingController(text: name),
      amount = TextEditingController(text: amount);

  final TextEditingController name;
  final TextEditingController amount;

  void dispose() {
    name.dispose();
    amount.dispose();
  }
}

class PurchaseFormScreen extends StatefulWidget {
  const PurchaseFormScreen({super.key});

  @override
  State<PurchaseFormScreen> createState() => _PurchaseFormScreenState();
}

class _PurchaseFormScreenState extends State<PurchaseFormScreen> {
  late String _supplier;
  late final List<_LineDraft> _lines;
  late final List<_CostDraft> _costs;
  String? _error;

  @override
  void initState() {
    super.initState();
    _supplier = suppliers.first;
    _lines = [
      _LineDraft(
        product: 'Polera Oversize Negra',
        variant: 'Negro / M',
        quantity: '10',
        unitCost: '11000',
      ),
    ];
    _costs = [
      _CostDraft(name: 'Envío', amount: '18000'),
      _CostDraft(name: 'Bolsas', amount: '8000'),
    ];
    _watchAll();
  }

  void _watch(TextEditingController controller) {
    controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void _watchAll() {
    for (final line in _lines) {
      _watch(line.quantity);
      _watch(line.unitCost);
    }
    for (final cost in _costs) {
      _watch(cost.amount);
    }
  }

  @override
  void dispose() {
    for (final line in _lines) {
      line.dispose();
    }
    for (final cost in _costs) {
      cost.dispose();
    }
    super.dispose();
  }

  int _money(String raw) {
    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
  }

  int _lineSubtotal(_LineDraft line) {
    return _money(line.quantity.text) * _money(line.unitCost.text);
  }

  int get _merchandise =>
      _lines.fold(0, (sum, line) => sum + _lineSubtotal(line));

  int get _extrasTotal =>
      _costs.fold(0, (sum, cost) => sum + _money(cost.amount.text));

  void _addLine() {
    final product = purchaseVariants.keys.first;
    final line = _LineDraft(
      product: product,
      variant: purchaseVariants[product]!.first,
      quantity: '1',
      unitCost: '',
    );
    _watch(line.quantity);
    _watch(line.unitCost);
    setState(() => _lines.add(line));
  }

  void _addCost() {
    final cost = _CostDraft(name: '', amount: '');
    _watch(cost.amount);
    setState(() => _costs.add(cost));
  }

  void _confirm() {
    for (final line in _lines) {
      if (_money(line.quantity.text) <= 0 || _money(line.unitCost.text) <= 0) {
        setState(() => _error = 'Indica cantidad y costo en cada prenda.');
        return;
      }
    }

    final extras = <ExtraCost>[];
    for (final cost in _costs) {
      final name = cost.name.text.trim();
      final amount = _money(cost.amount.text);
      if (name.isEmpty && amount == 0) continue;
      if (name.isEmpty || amount <= 0) {
        setState(
          () => _error = 'Cada costo adicional necesita nombre y monto.',
        );
        return;
      }
      extras.add(ExtraCost(name: name, amount: amount));
    }

    final now = DateTime.now();
    final number = purchaseCatalog.nextNumber;
    purchaseCatalog.add(
      Purchase(
        id: 'local-$number',
        number: number,
        supplier: _supplier,
        date: DateTime(now.year, now.month, now.day),
        status: PurchaseStatus.completed,
        lines: [
          for (final line in _lines)
            PurchaseLine(
              productName: line.product,
              variantLabel: line.variant,
              quantity: _money(line.quantity.text),
              unitCost: _money(line.unitCost.text),
            ),
        ],
        extras: extras,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Compra lista en esta sesión.')),
      );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final total = _merchandise + _extrasTotal;

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva compra')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        children: [
          Text('Proveedor', style: textTheme.bodySmall),
          const SizedBox(height: AppSpacing.xs),
          SupplierSelector(
            suppliers: suppliers,
            selected: _supplier,
            onSelected: (value) => setState(() => _supplier = value),
          ),
          const SectionTitle('Prendas'),
          Text(
            'Cada línea es una variante: producto, talla y costo.',
            style: textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          for (var i = 0; i < _lines.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.lg),
            _LineFields(
              index: i,
              line: _lines[i],
              subtotal: _lineSubtotal(_lines[i]),
              onProduct: (product) {
                setState(() {
                  _lines[i].product = product;
                  _lines[i].variant = purchaseVariants[product]!.first;
                });
              },
              onVariant: (variant) => setState(() => _lines[i].variant = variant),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(
            onPressed: _addLine,
            child: const Text('Agregar otra prenda'),
          ),
          const SectionTitle('Costos adicionales'),
          Text(
            'Envío, bolsas, etiquetas u otro gasto de esta compra.',
            style: textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          for (final cost in _costs) ...[
            _CostFields(cost: cost),
            const SizedBox(height: AppSpacing.sm),
          ],
          OutlinedButton(onPressed: _addCost, child: const Text('Agregar costo')),
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
              Text(
                'Subtotal ${formatClp(_merchandise)}',
                style: textTheme.bodySmall,
              ),
              Text('Total ${formatClp(total)}', style: textTheme.titleMedium),
              if (_error != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _error!,
                  style: textTheme.bodyMedium?.copyWith(color: AppColors.rose),
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              FilledButton(
                key: const Key('confirm-purchase'),
                onPressed: _confirm,
                child: const Text('Confirmar compra'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LineFields extends StatelessWidget {
  const _LineFields({
    required this.index,
    required this.line,
    required this.subtotal,
    required this.onProduct,
    required this.onVariant,
  });

  final int index;
  final _LineDraft line;
  final int subtotal;
  final ValueChanged<String> onProduct;
  final ValueChanged<String> onVariant;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final variants = purchaseVariants[line.product] ?? const <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Producto', style: textTheme.bodySmall),
        const SizedBox(height: AppSpacing.xs),
        DropdownButtonFormField<String>(
          key: ValueKey('purchase-product-$index-${line.product}'),
          initialValue: line.product,
          isExpanded: true,
          items: [
            for (final product in purchaseVariants.keys)
              DropdownMenuItem(value: product, child: Text(product)),
          ],
          onChanged: (value) {
            if (value != null) onProduct(value);
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        Text('Variante', style: textTheme.bodySmall),
        const SizedBox(height: AppSpacing.xs),
        DropdownButtonFormField<String>(
          key: ValueKey('purchase-variant-$index-${line.product}-${line.variant}'),
          initialValue: line.variant,
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
        TextField(
          controller: line.quantity,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(hintText: 'Cantidad'),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text('Costo unitario', style: textTheme.bodySmall),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: line.unitCost,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(hintText: 'Costo unitario'),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text('Subtotal ${formatClp(subtotal)}', style: textTheme.titleMedium),
      ],
    );
  }
}

class _CostFields extends StatelessWidget {
  const _CostFields({required this.cost});

  final _CostDraft cost;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            controller: cost.name,
            decoration: const InputDecoration(hintText: 'Nombre'),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          flex: 2,
          child: TextField(
            controller: cost.amount,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(hintText: 'Monto'),
          ),
        ),
      ],
    );
  }
}
