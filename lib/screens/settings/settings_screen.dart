import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/data/mock/settings_store.dart';
import 'package:afyra/screens/settings/about_screen.dart';
import 'package:afyra/screens/settings/appearance_screen.dart';
import 'package:afyra/screens/settings/business_profile_screen.dart';
import 'package:afyra/screens/settings/inventory_settings_screen.dart';
import 'package:afyra/screens/settings/notifications_settings_screen.dart';
import 'package:afyra/screens/settings/preferences_screen.dart';
import 'package:afyra/screens/settings/profile_screen.dart';
import 'package:afyra/widgets/app_feedback.dart';
import 'package:afyra/widgets/settings_group.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable: settingsStore,
          builder: (context, _) {
            final settings = settingsStore;
            return ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              children: [
                Text(
                  'Personaliza la aplicación y tu negocio.',
                  style: textTheme.bodyLarge,
                ),
                SettingsGroup(
                  title: 'Perfil del negocio',
                  children: [
                    SettingsNavTile(
                      icon: Icons.storefront_outlined,
                      title: 'Información del negocio',
                      subtitle: '${settings.businessName} · ${settings.instagram}',
                      onTap: () => _open(context, const BusinessProfileScreen()),
                    ),
                  ],
                ),
                SettingsGroup(
                  title: 'Cuenta',
                  children: [
                    SettingsNavTile(
                      icon: Icons.person_outline,
                      title: 'Mi perfil',
                      subtitle: '${settings.userName} · ${settings.role}',
                      onTap: () => _open(context, const ProfileScreen()),
                    ),
                    SettingsNavTile(
                      icon: Icons.logout_outlined,
                      title: 'Cerrar sesión',
                      subtitle: 'Solo en esta demostración',
                      onTap: () => confirmSignOut(context),
                    ),
                  ],
                ),
                SettingsGroup(
                  title: 'Preferencias',
                  children: [
                    SettingsNavTile(
                      icon: Icons.tune_outlined,
                      title: 'Preferencias',
                      subtitle: 'Moneda, costos y confirmaciones',
                      onTap: () => _open(context, const PreferencesScreen()),
                    ),
                    SettingsNavTile(
                      icon: Icons.inventory_2_outlined,
                      title: 'Inventario',
                      subtitle: 'Stock bajo desde ${settings.lowStockThreshold} unidades',
                      onTap: () => _open(context, const InventorySettingsScreen()),
                    ),
                  ],
                ),
                SettingsGroup(
                  title: 'Notificaciones',
                  children: [
                    SettingsNavTile(
                      icon: Icons.notifications_outlined,
                      title: 'Alertas',
                      subtitle: 'Stock, ventas, LIVE y recordatorios',
                      onTap: () => _open(context, const NotificationsSettingsScreen()),
                    ),
                  ],
                ),
                SettingsGroup(
                  title: 'Apariencia',
                  children: [
                    SettingsNavTile(
                      icon: Icons.palette_outlined,
                      title: 'Tema de la aplicación',
                      subtitle: settings.appearance,
                      onTap: () => _open(context, const AppearanceScreen()),
                    ),
                  ],
                ),
                SettingsGroup(
                  title: 'Información',
                  children: [
                    SettingsNavTile(
                      icon: Icons.info_outline,
                      title: 'Acerca de la aplicación',
                      subtitle: 'Versión 1.0.0 · demostración',
                      onTap: () => _open(context, const AboutScreen()),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }
}

Future<void> confirmSignOut(BuildContext context) async {
  final accepted = await confirmAppAction(
    context,
    title: '¿Cerrar sesión?',
    message: 'Esta acción cerrará tu sesión actual.',
    confirmLabel: 'Cerrar sesión',
  );
  if (!accepted || !context.mounted) return;
  showAppMessage(context, 'Sesión cerrada en esta demostración.');
}
