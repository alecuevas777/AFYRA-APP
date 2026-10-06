import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';

class SupplierSelector extends StatelessWidget {
  const SupplierSelector({
    super.key,
    required this.suppliers,
    required this.selected,
    required this.onSelected,
  });

  final List<String> suppliers;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < suppliers.length; i++) ...[
            if (i > 0) const Divider(height: 1),
            InkWell(
              onTap: () => onSelected(suppliers[i]),
              child: Container(
                color: suppliers[i] == selected ? AppColors.blush : AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: suppliers[i] == selected
                            ? AppColors.ink
                            : AppColors.line,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        suppliers[i],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
