import 'dart:async';

import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/models/live_session.dart';

class LiveTimer extends StatefulWidget {
  const LiveTimer({super.key, required this.session});

  final LiveSession session;

  @override
  State<LiveTimer> createState() => _LiveTimerState();
}

class _LiveTimerState extends State<LiveTimer> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    if (widget.session.status == LiveStatus.active) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      formatDuration(widget.session.elapsed),
      style: Theme.of(context).textTheme.labelLarge,
    );
  }
}

class LiveStatusBadge extends StatelessWidget {
  const LiveStatusBadge({super.key, required this.status});

  final LiveStatus status;

  @override
  Widget build(BuildContext context) {
    final active = status == LiveStatus.active;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? AppColors.ink : AppColors.muted,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          active ? 'LIVE' : 'Finalizado',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            letterSpacing: 0.6,
          ),
        ),
      ],
    );
  }
}
