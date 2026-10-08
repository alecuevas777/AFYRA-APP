import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/data/mock/settings_store.dart';
import 'package:afyra/widgets/settings_group.dart';

class InventorySettingsScreen extends StatelessWidget {
  const InventorySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Inventario')),
      body: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable: settingsStore,
          builder: (context, _) {
            final threshold = settingsStore.lowStockThreshold;
            final units = threshold == 1 ? '1 unidad' : '$threshold unidades';
            return ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              children: [
                Text('Define cuándo una prenda pide atención.', style: textTheme.bodyLarge),
                SettingsGroup(
                  title: 'Umbral de stock bajo',
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text(units, style: textTheme.titleMedium)),
                              _Step(
                                icon: Icons.remove,
                                enabled: threshold > 1,
                                onTap: () => settingsStore.setLowStockThreshold(threshold - 1),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              _Step(
                                icon: Icons.add,
                                enabled: threshold < 20,
                                onTap: () => settingsStore.setLowStockThreshold(threshold + 1),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Los productos con $units o menos serán considerados de stock bajo.',
                            style: textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SettingsGroup(
                  title: 'Alertas',
                  children: [
                    SettingsSwitchTile(
                      title: 'Alertas de stock bajo',
                      subtitle: 'Aviso cuando una prenda llegue a ese límite.',
                      value: settingsStore.lowStockAlerts,
                      onChanged: settingsStore.setLowStockAlerts,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'El inventario actual sigue usando su propia regla. Este número queda listo para conectarlo después.',
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

class _Step extends StatelessWidget {
  const _Step({required this.icon, required this.enabled, required this.onTap});

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled ? AppColors.blush : AppColors.line,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, size: 20, color: enabled ? AppColors.ink : AppColors.muted),
        ),
      ),
    );
  }
}
