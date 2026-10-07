import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_spacing.dart';

class CustomerContactActions extends StatelessWidget {
  const CustomerContactActions({
    super.key,
    required this.onEdit,
    required this.onWhatsapp,
    required this.onCall,
  });

  final VoidCallback onEdit;
  final VoidCallback onWhatsapp;
  final VoidCallback onCall;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _Action(label: 'Editar', onPressed: onEdit)),
        const SizedBox(width: AppSpacing.xs),
        Expanded(child: _Action(label: 'WhatsApp', onPressed: onWhatsapp)),
        const SizedBox(width: AppSpacing.xs),
        Expanded(child: _Action(label: 'Llamar', onPressed: onCall)),
      ],
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        minimumSize: const Size(0, 46),
      ),
      onPressed: onPressed,
      child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}
