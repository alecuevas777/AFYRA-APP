import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/data/mock/customer_catalog.dart';
import 'package:afyra/models/customer.dart';
import 'package:afyra/widgets/customer_form.dart';

class CustomerFormScreen extends StatefulWidget {
  const CustomerFormScreen({super.key, this.customer});

  final Customer? customer;

  @override
  State<CustomerFormScreen> createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends State<CustomerFormScreen> {
  final _formKey = GlobalKey<CustomerFormState>();

  bool get _editing => widget.customer != null;

  Future<void> _save() async {
    final customer = _formKey.currentState?.tryBuild();
    if (customer == null || !mounted) return;
    if (_editing) {
      customerCatalog.update(customer);
    } else {
      customerCatalog.add(customer);
    }
    await showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
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
                Text(
                  _editing ? 'Cliente actualizado' : 'Cliente guardado',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(customer.name, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Listo'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_editing ? 'Editar cliente' : 'Nuevo cliente')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          CustomerForm(key: _formKey, customer: widget.customer),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: FilledButton(
            key: const Key('save-customer'),
            onPressed: _save,
            child: const Text('Guardar cliente'),
          ),
        ),
      ),
    );
  }
}
