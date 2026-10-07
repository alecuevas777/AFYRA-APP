import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/models/live_session.dart';

class LiveSaleItem extends StatelessWidget {
  const LiveSaleItem({super.key, required this.sale});

  final LiveSaleRecord sale;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 48,
            child: Text(shortTime(sale.at), style: textTheme.bodySmall),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sale.customerLabel, style: textTheme.titleMedium),
                Text(
                  '${sale.productName} · ${sale.variantLabel}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(formatClp(sale.total), style: textTheme.titleMedium),
        ],
      ),
    );
  }
}
