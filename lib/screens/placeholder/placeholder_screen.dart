import 'package:flutter/material.dart';

import 'package:afyra/widgets/status_views.dart';

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return EmptyView(title: title, message: message);
  }
}
