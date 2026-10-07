import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';

class CustomerAvatar extends StatelessWidget {
  const CustomerAvatar({super.key, required this.initials, this.size = 44});

  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.blush,
        shape: BoxShape.circle,
      ),
      child: Text(
        initials,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
