import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';

/// Outfit para leer. Cormorant solo en palabras de marca.
abstract final class AppTypography {
  static const sans = 'Outfit';
  static const accentFamily = 'CormorantGaramond';

  static const accent = TextStyle(
    fontFamily: accentFamily,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w500,
    fontSize: 40,
    height: 0.9,
    color: AppColors.ink,
  );
}
