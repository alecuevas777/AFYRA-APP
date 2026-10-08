import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/data/mock/settings_store.dart';
import 'package:afyra/widgets/settings_group.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Preferencias')),
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
                Text('Así se ve la información de tu tienda.', style: textTheme.bodyLarge),
                SettingsGroup(
                  title: 'Moneda',
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        children: [
                          Expanded(child: Text('Moneda', style: textTheme.bodyLarge)),
                          Text('Peso chileno (CLP)', style: textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
                SettingsGroup(
                  title: 'Visibilidad',
                  children: [
                    SettingsSwitchTile(
                      title: 'Mostrar costos de productos',
                      subtitle: 'El costo estimado sigue disponible en la ficha.',
                      value: settings.showCosts,
                      onChanged: settingsStore.setShowCosts,
                    ),
                    SettingsSwitchTile(
                      title: 'Mostrar ganancias estimadas',
                      subtitle: 'La ganancia se calcula con el costo de cada prenda.',
                      value: settings.showProfits,
                      onChanged: settingsStore.setShowProfits,
                    ),
                    SettingsSwitchTile(
                      title: 'Confirmar acciones importantes',
                      subtitle: 'Por ejemplo, finalizar un LIVE o cerrar sesión.',
                      value: settings.confirmActions,
                      onChanged: settingsStore.setConfirmActions,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Estos interruptores preparan la preferencia. Todavía no ocultan cifras en el resto de la app.',
                  style: textTheme.bodySmall?.copyWith(color: AppColors.muted),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
