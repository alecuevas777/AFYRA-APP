import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/data/mock/settings_store.dart';
import 'package:afyra/screens/settings/settings_screen.dart';
import 'package:afyra/widgets/app_feedback.dart';
import 'package:afyra/widgets/customer_avatar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _editing = false;
  late final TextEditingController _name;
  late final TextEditingController _email;
  String? _nameError;
  String? _emailError;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: settingsStore.userName);
    _email = TextEditingController(text: settingsStore.email);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  void _save() {
    final name = _name.text.trim();
    final email = _email.text.trim();
    final nameError = name.isEmpty ? 'Escribe tu nombre.' : null;
    final emailError = email.contains('@') ? null : 'Escribe un correo.';
    if (nameError != null || emailError != null) {
      setState(() {
        _nameError = nameError;
        _emailError = emailError;
      });
      return;
    }
    settingsStore.saveProfile(name: name, email: email);
    setState(() => _editing = false);
    showAppMessage(context, 'Perfil actualizado');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Mi perfil')),
      body: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable: settingsStore,
          builder: (context, _) {
            final settings = settingsStore;
            return ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              children: [
                Center(child: CustomerAvatar(initials: _initials(settings.userName), size: 72)),
                const SizedBox(height: AppSpacing.md),
                if (!_editing) ...[
                  Text(settings.userName, style: textTheme.titleLarge, textAlign: TextAlign.center),
                  const SizedBox(height: AppSpacing.xs),
                  Text(settings.email, style: textTheme.bodyMedium, textAlign: TextAlign.center),
                  const SizedBox(height: AppSpacing.xs),
                  Text(settings.role, style: textTheme.bodySmall, textAlign: TextAlign.center),
                  const SizedBox(height: AppSpacing.xl),
                  FilledButton(
                    onPressed: () => setState(() => _editing = true),
                    child: const Text('Editar perfil'),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  OutlinedButton(
                    onPressed: () => confirmSignOut(context),
                    child: const Text('Cerrar sesión'),
                  ),
                ] else ...[
                  Text('Cambiar información', style: textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    key: const Key('profile-name'),
                    controller: _name,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(labelText: 'Nombre', errorText: _nameError),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    key: const Key('profile-email'),
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Correo', errorText: _emailError),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text('Rol: ${settings.role}', style: textTheme.bodySmall),
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton(
                    onPressed: _save,
                    child: const Text('Guardar cambios'),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

String _initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((part) => part.isNotEmpty).toList();
  if (parts.isEmpty) return '?';
  String mark(String word) => word.substring(0, 1).toUpperCase();
  if (parts.length == 1) return mark(parts.first);
  return '${mark(parts.first)}${mark(parts.last)}';
}
