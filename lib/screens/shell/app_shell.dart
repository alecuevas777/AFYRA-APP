import 'package:flutter/material.dart';

import 'package:afyra/screens/dashboard/dashboard_screen.dart';
import 'package:afyra/screens/more/more_screen.dart';
import 'package:afyra/screens/placeholder/placeholder_screen.dart';
import 'package:afyra/screens/products/product_form_screen.dart';
import 'package:afyra/screens/products/products_screen.dart';
import 'package:afyra/screens/purchases/purchases_screen.dart';
import 'package:afyra/screens/sales/sale_form_screen.dart';
import 'package:afyra/screens/sales/sales_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  void _onAction(String label) {
    if (label == 'Producto') {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const ProductFormScreen()),
      );
      return;
    }

    if (label == 'Compra') {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const PurchasesScreen()),
      );
      return;
    }

    if (label == 'Venta') {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const SaleFormScreen()),
      );
      return;
    }

    final text = label == 'LIVE'
        ? 'El modo LIVE se construye en una etapa posterior.'
        : '$label estará disponible en una próxima etapa.';

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      DashboardScreen(onAction: _onAction),
      const ProductsScreen(),
      const SalesScreen(),
      const PlaceholderScreen(
        title: 'LIVE',
        message: 'El modo LIVE se construye en la etapa 5.',
      ),
      const MoreScreen(),
    ];

    return Scaffold(
      body: SafeArea(bottom: false, child: pages[_index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.checkroom_outlined),
            selectedIcon: Icon(Icons.checkroom),
            label: 'Productos',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag),
            label: 'Ventas',
          ),
          NavigationDestination(
            icon: Icon(Icons.videocam_outlined),
            selectedIcon: Icon(Icons.videocam),
            label: 'LIVE',
          ),
          NavigationDestination(
            icon: Icon(Icons.more_horiz),
            selectedIcon: Icon(Icons.more_horiz),
            label: 'Más',
          ),
        ],
      ),
    );
  }
}
