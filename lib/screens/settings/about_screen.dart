import 'package:flutter/material.dart';

import 'package:afyra/core/constants/app_constants.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/widgets/app_feedback.dart';
import 'package:afyra/widgets/settings_group.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
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
            Text(AppConstants.appName, style: textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(AppConstants.description, style: textTheme.bodyLarge),
            const SizedBox(height: AppSpacing.lg),
            Text('Versión ${AppConstants.version}', style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text('Versión de demostración', style: textTheme.bodySmall),
            SettingsGroup(
              title: 'Documentos',
              children: [
                SettingsNavTile(
                  icon: Icons.description_outlined,
                  title: 'Términos y condiciones',
                  onTap: () => showAppMessage(context, 'Los términos se publicarán más adelante.'),
                ),
                SettingsNavTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Política de privacidad',
                  onTap: () => showAppMessage(context, 'La política de privacidad se publicará más adelante.'),
                ),
                SettingsNavTile(
                  icon: Icons.mail_outline,
                  title: 'Contacto',
                  subtitle: 'hola@ayra.cl',
                  onTap: () => showAppMessage(context, 'El contacto se abrirá más adelante.'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
