import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/models/history_item.dart';
import 'package:afyra/widgets/history_icon.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({
    super.key,
    required this.item,
    required this.onTap,
    this.showLine = true,
  });

  final HistoryItem item;
  final VoidCallback onTap;
  final bool showLine;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final alert = item.status == 'Cancelada';
    final trailing = item.quantityLabel ?? (item.amount == null ? null : formatClp(item.amount!));

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 16,
            child: Column(
              children: [
                const SizedBox(height: 22),
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppColors.blushDeep,
                    shape: BoxShape.circle,
                  ),
                ),
                if (showLine)
                  Container(
                    width: 1,
                    height: 78,
                    color: AppColors.blushDeep,
                  ),
              ],
            ),
          ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Material(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: onTap,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        HistoryIcon(kind: item.kind),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.titleMedium,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodyMedium,
                              ),
                              Text(
                                item.detail,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodySmall,
                              ),
                              if (item.status != null)
                                Text(
                                  item.status!,
                                  style: textTheme.labelMedium?.copyWith(
                                    color: alert ? AppColors.rose : AppColors.muted,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (trailing != null)
                              Text(
                                trailing,
                                style: textTheme.titleMedium,
                              ),
                            const SizedBox(height: 2),
                            Text(shortTime(item.at), style: textTheme.bodySmall),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
