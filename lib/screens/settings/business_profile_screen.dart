import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/data/mock/settings_store.dart';
import 'package:afyra/widgets/app_feedback.dart';

class BusinessProfileScreen extends StatefulWidget {
  const BusinessProfileScreen({super.key});

  @override
  State<BusinessProfileScreen> createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
  late final TextEditingController _name;
  late final TextEditingController _instagram;
  late final TextEditingController _whatsapp;
  late final TextEditingController _phone;
  late final TextEditingController _address;
  String? _nameError;

  @override
  void initState() {
    super.initState();
    final settings = settingsStore;
    _name = TextEditingController(text: settings.businessName);
    _instagram = TextEditingController(text: settings.instagram);
    _whatsapp = TextEditingController(text: settings.whatsapp);
    _phone = TextEditingController(text: settings.phone);
    _address = TextEditingController(text: settings.address);
  }

  @override
  void dispose() {
    _name.dispose();
    _instagram.dispose();
    _whatsapp.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  void _save() {
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = 'Escribe el nombre del negocio.');
      return;
    }
    settingsStore.saveBusiness(
      name: name,
      instagram: _instagram.text.trim(),
      whatsapp: _whatsapp.text.trim(),
      phone: _phone.text.trim(),
      address: _address.text.trim(),
    );
    showAppMessage(context, 'Información actualizada');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Información del negocio')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          children: [
            const _LogoPlaceholder(),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'El logo de la marca se mantiene. Aquí solo se ve el espacio de la imagen.',
              style: textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              key: const Key('business-name'),
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Nombre del negocio',
                errorText: _nameError,
              ),
              onChanged: (_) {
                if (_nameError != null) setState(() => _nameError = null);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _instagram,
              decoration: const InputDecoration(labelText: 'Instagram'),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _whatsapp,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'WhatsApp'),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Teléfono'),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _address,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Dirección'),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: _save,
              child: const Text('Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoPlaceholder extends StatelessWidget {
  const _LogoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 88,
        height: 88,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.blush,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: const Icon(Icons.storefront_outlined, size: 32),
      ),
    );
  }
}
