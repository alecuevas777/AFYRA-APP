import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/data/mock/live_catalog.dart';
import 'package:afyra/models/live_session.dart';
import 'package:afyra/models/product.dart';
import 'package:afyra/models/sale.dart';
import 'package:afyra/widgets/customer_selector.dart';
import 'package:afyra/widgets/payment_method_selector.dart';
import 'package:afyra/widgets/soft_entrance.dart';
import 'package:afyra/widgets/variant_groups.dart';

Future<void> openQuickSale(BuildContext context, Product product) async {
  final record = await showModalBottomSheet<LiveSaleRecord>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
    ),
    builder: (context) {
      final height = MediaQuery.sizeOf(context).height * 0.86;
      return SizedBox(height: height, child: QuickSaleSheet(product: product));
    },
  );

  if (record == null || !context.mounted) return;
  await showDialog<void>(
    context: context,
    builder: (context) => LiveSaleFeedback(sale: record),
  );
}

class QuickSaleSheet extends StatefulWidget {
  const QuickSaleSheet({super.key, required this.product});

  final Product product;

  @override
  State<QuickSaleSheet> createState() => _QuickSaleSheetState();
}

class _QuickSaleSheetState extends State<QuickSaleSheet> {
  late String _color;
  late String _size;
  var _quantity = 1;
  String? _customerName;
  var _payment = PaymentMethod.transfer;

  LiveSession? get _session => liveCatalog.active;

  int get _stock {
    final session = _session;
    if (session == null) return 0;
    return session.stockOf(widget.product.id, _color, _size);
  }

  @override
  void initState() {
    super.initState();
    final session = _session;
    final colors = widget.product.variantsByColor.keys.toList();
    _color = colors.isEmpty ? '' : colors.first;
    if (session != null) {
      for (final color in colors) {
        final hasStock = widget.product.variantsByColor[color]!.any(
          (variant) => session.stockOf(widget.product.id, color, variant.size) > 0,
        );
        if (hasStock) {
          _color = color;
          break;
        }
      }
    }
    _size = _firstSize(_color);
  }

  String _firstSize(String color) {
    final variants = widget.product.variantsByColor[color] ?? const <ProductVariant>[];
    if (variants.isEmpty) return '';
    final session = _session;
    if (session == null) return variants.first.size;
    ProductVariant? best;
    var bestStock = -1;
    for (final variant in variants) {
      final stock = session.stockOf(widget.product.id, color, variant.size);
      if (stock > bestStock) {
        best = variant;
        bestStock = stock;
      }
    }
    return best?.size ?? variants.first.size;
  }

  void _setColor(String color) {
    setState(() {
      _color = color;
      _size = _firstSize(color);
      _quantity = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final stock = _stock;
    final level = liveStockLevel(stock);
    final stockColor = level == LiveStockLevel.ok ? AppColors.ink : AppColors.rose;
    final colors = widget.product.variantsByColor.keys.toList();
    final sizes = widget.product.variantsByColor[_color] ?? const <ProductVariant>[];
    final total = widget.product.price * _quantity;

    return Column(
      children: [
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.line,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            children: [
              Text(widget.product.name, style: textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(formatClp(widget.product.price), style: textTheme.titleLarge),
              const SizedBox(height: AppSpacing.lg),
              Text('Color', style: textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final color in colors)
                    _ColorDot(
                      color: color,
                      selected: color == _color,
                      onTap: () => _setColor(color),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Talla', style: textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  for (final variant in sizes)
                    ChoiceChip(
                      label: Text(variant.size),
                      selected: variant.size == _size,
                      showCheckmark: false,
                      selectedColor: AppColors.ink,
                      backgroundColor: AppColors.white,
                      labelStyle: textTheme.labelLarge?.copyWith(
                        color: variant.size == _size ? AppColors.white : AppColors.ink,
                      ),
                      side: BorderSide(
                        color: variant.size == _size ? AppColors.ink : AppColors.line,
                      ),
                      onSelected: (_) => setState(() {
                        _size = variant.size;
                        _quantity = 1;
                      }),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Stock disponible', style: textTheme.bodySmall),
              const SizedBox(height: AppSpacing.xs),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                layoutBuilder: (currentChild, _) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: currentChild,
                  );
                },
                child: Text(
                  liveStockLabel(stock),
                  key: ValueKey('$stock-$_color-$_size'),
                  style: textTheme.titleMedium?.copyWith(color: stockColor),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Cantidad', style: textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  _Step(
                    icon: Icons.remove,
                    enabled: _quantity > 1,
                    onTap: () => setState(() => _quantity -= 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Text('$_quantity', style: textTheme.headlineMedium),
                  ),
                  _Step(
                    icon: Icons.add,
                    enabled: _quantity < stock,
                    onTap: () => setState(() => _quantity += 1),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(child: Text('Cliente', style: textTheme.titleMedium)),
                  TextButton(
                    onPressed: () async {
                      final choice = await showCustomerPicker(
                        context,
                        selectedName: _customerName,
                      );
                      if (choice == null || !mounted) return;
                      setState(() => _customerName = choice.customer?.name);
                    },
                    child: const Text('Elegir'),
                  ),
                ],
              ),
              Text(
                _customerName ?? 'Sin cliente',
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Método de pago', style: textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              PaymentMethodSelector(
                selected: _payment,
                onSelected: (method) => setState(() => _payment = method),
              ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Total', style: textTheme.bodyLarge),
                    const Spacer(),
                    Text(formatClp(total), style: textTheme.titleLarge),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    key: const Key('confirm-live-sale'),
                    onPressed: stock <= 0
                        ? null
                        : () {
                            final record = liveCatalog.sell(
                              product: widget.product,
                              color: _color,
                              size: _size,
                              quantity: _quantity,
                              payment: _payment,
                              customerName: _customerName,
                            );
                            Navigator.of(context).pop(record);
                          },
                    child: const Text('Confirmar venta'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: garmentSwatch(color),
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.ink : AppColors.line,
                  width: selected ? 2 : 1,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(color, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: enabled ? onTap : null,
      style: IconButton.styleFrom(
        backgroundColor: AppColors.blush,
        foregroundColor: AppColors.ink,
        minimumSize: const Size(48, 48),
      ),
      icon: Icon(icon),
    );
  }
}

class LiveSaleFeedback extends StatelessWidget {
  const LiveSaleFeedback({super.key, required this.sale});

  final LiveSaleRecord sale;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: SoftEntrance(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.blush,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 28),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Venta registrada', style: textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(formatClp(sale.total), style: textTheme.titleLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(sale.productName, style: textTheme.bodyLarge),
              Text(sale.variantLabel, style: textTheme.bodySmall),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Seguir vendiendo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
