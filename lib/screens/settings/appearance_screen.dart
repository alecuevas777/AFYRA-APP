import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/data/mock/settings_store.dart';
import 'package:afyra/widgets/app_feedback.dart';
import 'package:afyra/widgets/section_title.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  static const _options = ['Claro', 'Oscuro', 'Automático'];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Apariencia')),
      body: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable: settingsStore,
          builder: (context, _) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              children: [
                Text('Tema de la aplicación', style: textTheme.bodyLarge),
                const SectionTitle('Tema'),
                Material(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      for (var i = 0; i < _options.length; i++) ...[
                        if (i > 0) const Divider(height: 1),
                        _ThemeOption(
                          label: _options[i],
                          selected: settingsStore.appearance == _options[i],
                          onTap: () {
                            settingsStore.setAppearance(_options[i]);
                            showAppMessage(
                              context,
                              _options[i] == 'Claro'
                                  ? 'Tema claro activo.'
                                  : 'Preferencia guardada. La app sigue en claro hasta tener modo noche.',
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'El blush, el negro y el fondo claro se mantienen. Oscuro y automático quedan preparados.',
                  style: textTheme.bodySmall,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 20,
              color: selected ? AppColors.ink : AppColors.muted,
            ),
          ],
        ),
      ),
    );
  }
}
