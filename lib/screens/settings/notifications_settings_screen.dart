import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/data/mock/settings_store.dart';
import 'package:afyra/widgets/settings_group.dart';

class NotificationsSettingsScreen extends StatelessWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
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
                Text('Elige qué alertas quieres recibir.', style: textTheme.bodyLarge),
                SettingsGroup(
                  title: 'Alertas',
                  children: [
                    SettingsSwitchTile(
                      title: 'Stock bajo',
                      subtitle: 'Recibe una alerta cuando un producto alcance el límite configurado.',
                      value: settings.lowStockAlerts,
                      onChanged: settingsStore.setLowStockAlerts,
                    ),
                    SettingsSwitchTile(
                      title: 'Nueva venta',
                      subtitle: 'Recibe una alerta cuando se registre una nueva venta.',
                      value: settings.notifySales,
                      onChanged: settingsStore.setNotifySales,
                    ),
                    SettingsSwitchTile(
                      title: 'Resumen de LIVE',
                      subtitle: 'Recibe un resumen cuando finalice un LIVE.',
                      value: settings.notifyLiveSummary,
                      onChanged: settingsStore.setNotifyLiveSummary,
                    ),
                    SettingsSwitchTile(
                      title: 'Recordatorios',
                      subtitle: 'Recibe recordatorios importantes sobre tu negocio.',
                      value: settings.notifyReminders,
                      onChanged: settingsStore.setNotifyReminders,
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
}
