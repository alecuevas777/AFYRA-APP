import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/models/history_item.dart';

class HistoryIcon extends StatelessWidget {
  const HistoryIcon({super.key, required this.kind});

  final HistoryKind kind;

  @override
  Widget build(BuildContext context) {
    final icon = switch (kind) {
      HistoryKind.sale => Icons.shopping_bag_outlined,
      HistoryKind.purchase => Icons.receipt_long_outlined,
      HistoryKind.inventory => Icons.warehouse_outlined,
      HistoryKind.live => Icons.videocam_outlined,
    };

    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.blush,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 18, color: AppColors.ink),
    );
  }
}
