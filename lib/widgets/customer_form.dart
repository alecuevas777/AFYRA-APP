import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/models/customer.dart';

class CustomerForm extends StatefulWidget {
  const CustomerForm({super.key, this.customer, this.compact = false});

  final Customer? customer;
  final bool compact;

  @override
  State<CustomerForm> createState() => CustomerFormState();
}

class CustomerFormState extends State<CustomerForm> {
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _whatsapp;
  late final TextEditingController _instagram;
  late final TextEditingController _address;
  late final TextEditingController _notes;
  String? _nameError;
  String? _phoneError;

  @override
  void initState() {
    super.initState();
    final customer = widget.customer;
    _name = TextEditingController(text: customer?.name ?? '');
    _phone = TextEditingController(text: customer?.phone ?? '');
    _whatsapp = TextEditingController(text: customer?.whatsapp ?? '');
    _instagram = TextEditingController(text: customer?.instagram ?? '');
    _address = TextEditingController(text: customer?.address ?? '');
    _notes = TextEditingController(text: customer?.notes ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _whatsapp.dispose();
    _instagram.dispose();
    _address.dispose();
    _notes.dispose();
    super.dispose();
  }

  Customer? tryBuild() {
    final name = _name.text.trim();
    final phone = _phone.text.trim();
    final nameError = name.isEmpty ? 'Escribe el nombre.' : null;
    final phoneError = phone.length < 8 ? 'Escribe un teléfono.' : null;
    if (nameError != null || phoneError != null) {
      setState(() {
        _nameError = nameError;
        _phoneError = phoneError;
      });
      return null;
    }

    final whatsapp = _whatsapp.text.trim();
    final current = widget.customer;
    return Customer(
      id: current?.id ?? 'local-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      phone: phone,
      whatsapp: whatsapp.isEmpty ? phone : whatsapp,
      instagram: _empty(_instagram),
      address: widget.compact ? current?.address : _empty(_address),
      notes: widget.compact ? current?.notes : _empty(_notes),
      joinedAt: current?.joinedAt ?? DateTime.now(),
      purchases: current?.purchases,
    );
  }

  String? _empty(TextEditingController controller) {
    final text = controller.text.trim();
    return text.isEmpty ? null : text;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          key: const Key('customer-name'),
          controller: _name,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: 'Nombre',
            errorText: _nameError,
          ),
          onChanged: (_) {
            if (_nameError != null) setState(() => _nameError = null);
          },
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          key: const Key('customer-phone'),
          controller: _phone,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Teléfono',
            errorText: _phoneError,
          ),
          onChanged: (_) {
            if (_phoneError != null) setState(() => _phoneError = null);
          },
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          key: const Key('customer-whatsapp'),
          controller: _whatsapp,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'WhatsApp',
            hintText: 'Si es el mismo, puedes dejarlo vacío',
          ),
        ),
        if (!widget.compact) ...[
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _instagram,
            decoration: const InputDecoration(labelText: 'Instagram'),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _address,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(labelText: 'Dirección'),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _notes,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(labelText: 'Notas'),
          ),
        ],
        if (_nameError != null || _phoneError != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Revisa los campos marcados.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.rose),
          ),
        ],
      ],
    );
  }
}

Future<Customer?> showQuickCustomerSheet(BuildContext context) {
  final formKey = GlobalKey<CustomerFormState>();

  return showModalBottomSheet<Customer>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Text('Nuevo cliente', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              CustomerForm(key: formKey, compact: true),
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                key: const Key('save-quick-customer'),
                onPressed: () {
                  final customer = formKey.currentState?.tryBuild();
                  if (customer == null) return;
                  Navigator.of(context).pop(customer);
                },
                child: const Text('Guardar cliente'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
