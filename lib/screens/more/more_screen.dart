import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/screens/customers/customers_screen.dart';
import 'package:afyra/screens/history/history_screen.dart';
import 'package:afyra/screens/reports/reports_screen.dart';
import 'package:afyra/screens/purchases/materials_screen.dart';
import 'package:afyra/screens/purchases/purchases_screen.dart';
import 'package:afyra/screens/purchases/real_cost_screen.dart';
import 'package:afyra/screens/settings/settings_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      children: [
        Text('Más', style: textTheme.titleLarge),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Actividad, personas y costos de la tienda.',
          style: textTheme.bodySmall,
        ),
        const SizedBox(height: AppSpacing.lg),
        _Entry(
          icon: Icons.history_outlined,
          title: 'Historial',
          subtitle: 'Ventas, compras, stock y LIVE',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const HistoryScreen()),
            );
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        _Entry(
          icon: Icons.insights_outlined,
          title: 'Reportes',
          subtitle: 'Ventas, márgenes y LIVE',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const ReportsScreen()),
            );
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        _Entry(
          icon: Icons.person_outline,
          title: 'Clientes',
          subtitle: 'Compras, contacto y frecuencia',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const CustomersScreen()),
            );
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        _Entry(
          icon: Icons.local_mall_outlined,
          title: 'Compras',
          subtitle: 'Historial, proveedores y totales',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const PurchasesScreen()),
            );
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        _Entry(
          icon: Icons.inventory_2_outlined,
          title: 'Materiales',
          subtitle: 'Bolsas, stickers y etiquetas',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const MaterialsScreen()),
            );
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        _Entry(
          icon: Icons.sell_outlined,
          title: 'Costo real',
          subtitle: 'Prenda más packaging',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const RealCostScreen()),
            );
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        _Entry(
          icon: Icons.settings_outlined,
          title: 'Configuración',
          subtitle: 'Negocio, avisos y apariencia',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
            );
          },
        ),
      ],
    );
  }
}

class _Entry extends StatelessWidget {
  const _Entry({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Icon(icon, size: 22),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(subtitle, style: textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
