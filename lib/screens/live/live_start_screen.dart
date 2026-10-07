import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/data/mock/live_catalog.dart';
import 'package:afyra/data/mock/live_mock.dart';

class LiveStartScreen extends StatefulWidget {
  const LiveStartScreen({super.key});

  @override
  State<LiveStartScreen> createState() => _LiveStartScreenState();
}

class _LiveStartScreenState extends State<LiveStartScreen> {
  late final TextEditingController _name;
  late final TextEditingController _description;
  var _missingName = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: 'Live ${shortDate(DateTime.now())}');
    _description = TextEditingController();
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  void _start() {
    if (liveCatalog.active != null) return;
    if (_name.text.trim().isEmpty) {
      setState(() => _missingName = true);
      return;
    }
    liveCatalog.start(name: _name.text, description: _description.text);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final busy = liveCatalog.active != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo LIVE')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          TextField(
            key: const Key('live-name'),
            controller: _name,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Nombre del LIVE',
              hintText: 'Live miércoles 7 oct',
            ),
            onChanged: (_) {
              if (_missingName) setState(() => _missingName = false);
            },
          ),
          if (_missingName) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Escribe un nombre para el LIVE.',
              style: textTheme.bodySmall?.copyWith(color: AppColors.rose),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _description,
            maxLines: 2,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Descripción',
              hintText: 'Opcional',
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.line),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _Figure(label: 'Productos disponibles', value: '$liveShopProducts'),
                ),
                Expanded(
                  child: _Figure(label: 'Stock total', value: '$liveShopUnits'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.blushDeep,
              foregroundColor: AppColors.ink,
            ),
            onPressed: busy ? null : _start,
            key: const Key('start-live'),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Dot(),
                SizedBox(width: AppSpacing.xs),
                Text('Iniciar LIVE'),
              ],
            ),
          ),
        ),
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
        Text(label, style: textTheme.bodySmall),
        const SizedBox(height: AppSpacing.xs),
        Text(value, style: textTheme.headlineMedium),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: AppColors.ink,
        shape: BoxShape.circle,
      ),
    );
  }
}
