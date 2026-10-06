import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      decoration: const InputDecoration(
        hintText: 'Buscar por nombre o SKU',
        prefixIcon: Icon(Icons.search, size: 20, color: AppColors.muted),
      ),
    );
  }
}
