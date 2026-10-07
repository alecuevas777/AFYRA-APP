import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/data/mock/customer_catalog.dart';
import 'package:afyra/models/customer.dart';
import 'package:afyra/screens/customers/customer_detail_screen.dart';
import 'package:afyra/screens/customers/customer_form_screen.dart';
import 'package:afyra/widgets/customer_card.dart';
import 'package:afyra/widgets/filter_chips.dart';
import 'package:afyra/widgets/search_field.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final _search = TextEditingController();
  var _filter = 'Todos';

  static const _filters = ['Todos', 'Recientes', 'Frecuentes', 'Sin compras'];

  @override
  void initState() {
    super.initState();
    _search.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        actions: [
          IconButton(
            key: const Key('add-customer'),
            tooltip: 'Nuevo cliente',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const CustomerFormScreen()),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable: customerCatalog,
          builder: (context, _) {
            final now = DateTime.now();
            final all = customerCatalog.customers;
            final visible = all.where((customer) {
              return customerMatchesFilter(customer, _filter, now) &&
                  customerMatchesQuery(customer, _search.text);
            }).toList();

            return ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              children: [
                Text(
                  'Gestiona tus clientes y conoce mejor sus compras.',
                  style: textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.lg),
                _Summary(
                  total: customerCatalog.total,
                  newcomers: customerCatalog.newcomers,
                  frequent: customerCatalog.frequent,
                  sales: customerCatalog.associatedSales,
                ),
                const SizedBox(height: AppSpacing.lg),
                SearchField(controller: _search, hint: 'Buscar cliente...'),
                const SizedBox(height: AppSpacing.md),
                FilterChips(
                  labels: _filters,
                  selected: _filter,
                  onSelected: (value) => setState(() => _filter = value),
                ),
                const SizedBox(height: AppSpacing.lg),
                if (all.isEmpty)
                  const _EmptyNote(
                    title: 'Todavía no hay clientes',
                    message: 'Agrega el primero para empezar a reconocer sus compras.',
                  )
                else if (visible.isEmpty)
                  const _EmptyNote(
                    title: 'No encontramos clientes',
                    message: 'Prueba con otro nombre o teléfono.',
                  )
                else
                  for (final customer in visible)
                    CustomerCard(
                      customer: customer,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => CustomerDetailScreen(customerId: customer.id),
                          ),
                        );
                      },
                    ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({
    required this.total,
    required this.newcomers,
    required this.frequent,
    required this.sales,
  });

  final int total;
  final int newcomers;
  final int frequent;
  final int sales;

  @override
  Widget build(BuildContext context) {
    final items = <(String, String)>[
      ('Clientes', '$total'),
      ('Nuevos', '$newcomers'),
      ('Frecuentes', '$frequent'),
      ('Ventas', '$sales'),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          for (final item in items)
            Expanded(child: _Figure(label: item.$1, value: item.$2)),
        ],
      ),
    );
  }
}

class _EmptyNote extends StatelessWidget {
  const _EmptyNote({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Column(
        children: [
          Text(title, style: textTheme.titleMedium, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            style: textTheme.bodyMedium?.copyWith(color: AppColors.muted),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 2),
        Text(value, style: textTheme.titleMedium),
      ],
    );
  }
}
