import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';

Future<({DateTime from, DateTime to})?> showHistoryRangeSheet(
  BuildContext context, {
  DateTime? from,
  DateTime? to,
}) {
  return showModalBottomSheet<({DateTime from, DateTime to})>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
    ),
    builder: (context) => _RangeSheet(from: from, to: to),
  );
}

class _RangeSheet extends StatefulWidget {
  const _RangeSheet({this.from, this.to});

  final DateTime? from;
  final DateTime? to;

  @override
  State<_RangeSheet> createState() => _RangeSheetState();
}

class _RangeSheetState extends State<_RangeSheet> {
  DateTime? _from;
  DateTime? _to;

  @override
  void initState() {
    super.initState();
    _from = widget.from;
    _to = widget.to;
  }

  Future<void> _pick({required bool start}) async {
    final current = start ? _from : _to;
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      helpText: start ? 'Fecha inicial' : 'Fecha final',
      cancelText: 'Cancelar',
      confirmText: 'Elegir',
    );
    if (picked == null) return;
    setState(() {
      if (start) {
        _from = picked;
      } else {
        _to = picked;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final ready = _from != null && _to != null;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Personalizado', style: textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Elige el período que quieres revisar.',
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            _DateButton(
              label: 'Fecha inicial',
              value: _from == null ? 'Elegir fecha' : mediumDate(_from!),
              onTap: () => _pick(start: true),
            ),
            const SizedBox(height: AppSpacing.sm),
            _DateButton(
              label: 'Fecha final',
              value: _to == null ? 'Elegir fecha' : mediumDate(_to!),
              onTap: () => _pick(start: false),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                key: const Key('apply-history-range'),
                onPressed: ready
                    ? () => Navigator.of(context).pop((from: _from!, to: _to!))
                    : null,
                child: const Text('Ver actividad'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  const _DateButton({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: textTheme.bodySmall),
                    const SizedBox(height: 2),
                    Text(value, style: textTheme.bodyLarge),
                  ],
                ),
              ),
              const Icon(Icons.calendar_today_outlined, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
