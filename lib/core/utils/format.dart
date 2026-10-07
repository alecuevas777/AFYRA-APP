String formatClp(int amount) {
  final negative = amount < 0;
  final digits = amount.abs().toString();
  final buffer = StringBuffer();

  for (var i = 0; i < digits.length; i++) {
    final remaining = digits.length - i;
    if (i > 0 && remaining % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(digits[i]);
  }

  return '${negative ? '-' : ''}\$$buffer';
}

String greetingFor(DateTime time) {
  final hour = time.hour;
  if (hour < 12) return 'Buenos días';
  if (hour < 19) return 'Buenas tardes';
  return 'Buenas noches';
}

String shortDate(DateTime date) {
  const weekdays = [
    'lunes',
    'martes',
    'miércoles',
    'jueves',
    'viernes',
    'sábado',
    'domingo',
  ];
  const months = [
    'ene',
    'feb',
    'mar',
    'abr',
    'may',
    'jun',
    'jul',
    'ago',
    'sep',
    'oct',
    'nov',
    'dic',
  ];

  return '${weekdays[date.weekday - 1]} ${date.day} ${months[date.month - 1]}';
}

String mediumDate(DateTime date) {
  const months = [
    'ene',
    'feb',
    'mar',
    'abr',
    'may',
    'jun',
    'jul',
    'ago',
    'sep',
    'oct',
    'nov',
    'dic',
  ];

  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

String shortTime(DateTime date) {
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

String relativeDay(DateTime date, [DateTime? now]) {
  final clock = now ?? DateTime.now();
  final start = DateTime(date.year, date.month, date.day);
  final today = DateTime(clock.year, clock.month, clock.day);
  final days = today.difference(start).inDays;
  if (days <= 0) return 'Hoy';
  if (days == 1) return 'Hace 1 día';
  return 'Hace $days días';
}

String formatDuration(Duration duration) {
  final hours = duration.inHours.toString().padLeft(2, '0');
  final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
  final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
  return '$hours:$minutes:$seconds';
}
