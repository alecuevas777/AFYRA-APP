import 'package:flutter/material.dart';

import 'package:afyra/core/constants/app_constants.dart';
import 'package:afyra/core/theme/app_theme.dart';
import 'package:afyra/screens/shell/app_shell.dart';

class AfyraApp extends StatelessWidget {
  const AfyraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const AppShell(),
    );
  }
}
