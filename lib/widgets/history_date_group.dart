import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_spacing.dart';

class HistoryDateGroup extends StatelessWidget {
  const HistoryDateGroup({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.sm),
      child: Text(label, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
