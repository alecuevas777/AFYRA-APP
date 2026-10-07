import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/models/live_session.dart';
import 'package:afyra/widgets/live_status_badge.dart';

class LiveHeader extends StatelessWidget {
  const LiveHeader({
    super.key,
    required this.session,
    required this.onFinish,
  });

  final LiveSession session;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LiveStatusBadge(status: LiveStatus.active),
              const SizedBox(height: AppSpacing.xs),
              Text(
                session.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 2),
              LiveTimer(session: session),
            ],
          ),
        ),
        TextButton(
          onPressed: onFinish,
          style: TextButton.styleFrom(foregroundColor: AppColors.rose),
          child: const Text('Finalizar'),
        ),
      ],
    );
  }
}

class LiveStats extends StatelessWidget {
  const LiveStats({
    super.key,
    required this.session,
    this.detailed = false,
  });

  final LiveSession session;
  final bool detailed;

  @override
  Widget build(BuildContext context) {
    final items = <(String, String)>[
      ('Ventas', '${session.salesCount}'),
      ('Ingresos', formatClp(session.income)),
      ('Prendas', '${session.unitsSold}'),
      ('Ganancia', formatClp(session.profit)),
      if (detailed) ...[
        ('Costo estimado', formatClp(session.estimatedCost)),
        ('Ticket promedio', formatClp(session.averageTicket)),
      ],
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.line),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const columns = 2;
          final width = (constraints.maxWidth - (columns - 1) * AppSpacing.xs) / columns;
          return Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.sm,
            children: [
              for (final item in items)
                SizedBox(
                  width: width,
                  child: _Stat(label: item.$1, value: item.$2),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.bodySmall),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(value, style: textTheme.titleMedium),
        ),
      ],
    );
  }
}

class LiveRanking extends StatelessWidget {
  const LiveRanking({super.key, required this.session});

  final LiveSession session;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final ranked = session.ranking().entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top = ranked.take(3).toList();

    if (top.isEmpty) {
      return Text('Todavía no hay ventas.', style: textTheme.bodyMedium);
    }

    return Column(
      children: [
        for (var i = 0; i < top.length; i++) ...[
          if (i > 0) const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  child: Text('${i + 1}', style: textTheme.titleMedium),
                ),
                Expanded(
                  child: Text(
                    top[i].key,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyLarge,
                  ),
                ),
                Text(
                  '${top[i].value} ${top[i].value == 1 ? 'venta' : 'ventas'}',
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
