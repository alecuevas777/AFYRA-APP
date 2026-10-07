import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/data/mock/customer_catalog.dart';
import 'package:afyra/data/mock/sale_mock.dart';
import 'package:afyra/models/sale.dart';
import 'package:afyra/widgets/customer_form.dart';
import 'package:afyra/widgets/search_field.dart';

class CustomerChoice {
  const CustomerChoice(this.customer);

  final SaleCustomer? customer;
}

Future<CustomerChoice?> showCustomerPicker(
  BuildContext context, {
  String? selectedName,
}) {
  final height = MediaQuery.sizeOf(context).height * 0.82;
  return showModalBottomSheet<CustomerChoice>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
    ),
    builder: (context) {
      return SizedBox(
        height: height,
        child: CustomerSelector(
          customers: saleCustomers,
          selectedName: selectedName,
          onSelected: (customer) {
            Navigator.of(context).pop(CustomerChoice(customer));
          },
        ),
      );
    },
  );
}

class CustomerSelector extends StatefulWidget {
  const CustomerSelector({
    super.key,
    required this.customers,
    required this.selectedName,
    required this.onSelected,
    this.canCreate = true,
  });

  final List<SaleCustomer> customers;
  final String? selectedName;
  final ValueChanged<SaleCustomer?> onSelected;
  final bool canCreate;

  @override
  State<CustomerSelector> createState() => _CustomerSelectorState();
}

class _CustomerSelectorState extends State<CustomerSelector> {
  final _search = TextEditingController();

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

  List<SaleCustomer> get _visible {
    final raw = _search.text.trim().toLowerCase();
    if (raw.isEmpty) return widget.customers;
    final compact = raw.replaceAll(' ', '');
    return widget.customers.where((customer) {
      final phone = customer.phone.replaceAll(' ', '').toLowerCase();
      final whatsapp = (customer.whatsapp ?? '').replaceAll(' ', '').toLowerCase();
      return customer.name.toLowerCase().contains(raw) ||
          phone.contains(compact) ||
          whatsapp.contains(compact);
    }).toList();
  }

  Future<void> _create() async {
    final created = await showQuickCustomerSheet(context);
    if (created == null || !mounted) return;
    customerCatalog.add(created);
    if (!mounted) return;
    widget.onSelected(
      SaleCustomer(
        name: created.name,
        phone: created.phone,
        whatsapp: created.whatsapp,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final visible = _visible;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
          child: Text('Seleccionar cliente', style: textTheme.titleLarge),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: SearchField(controller: _search, hint: 'Buscar cliente...'),
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          children: [
            Material(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              _Row(
                title: 'Venta sin cliente',
                subtitle: 'Se registra igual, sin asociar un nombre',
                selected: widget.selectedName == null,
                onTap: () => widget.onSelected(null),
              ),
              if (visible.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text(
                    'No encontramos clientes',
                    style: textTheme.bodyMedium,
                  ),
                )
              else
                for (final customer in visible) ...[
                  const Divider(height: 1),
                  _Row(
                    title: customer.name,
                    subtitle: customer.phone,
                    selected: widget.selectedName == customer.name,
                    onTap: () => widget.onSelected(customer),
                  ),
                ],
            ],
          ),
        ),
          ],
        ),
        ),
        if (widget.canCreate)
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  key: const Key('create-customer'),
                  onPressed: _create,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Crear nuevo cliente'),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: selected ? AppColors.blush : AppColors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: selected ? AppColors.ink : AppColors.line,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
