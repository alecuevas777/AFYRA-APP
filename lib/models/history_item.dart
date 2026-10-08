import 'package:afyra/models/sale.dart';

enum HistoryKind { sale, purchase, inventory, live }

/// Un movimiento de stock visto desde el historial.
/// Los números son de ejemplo: no modifican el inventario real.
class InventoryMovementDetail {
  const InventoryMovementDetail({
    required this.productName,
    required this.variantLabel,
    required this.quantity,
    required this.stockBefore,
    required this.stockAfter,
    required this.reason,
  });

  final String productName;
  final String variantLabel;
  final int quantity;
  final int stockBefore;
  final int stockAfter;
  final String reason;

  String get quantityLabel {
    final prefix = quantity > 0 ? '+' : '';
    final noun = quantity.abs() == 1 ? 'unidad' : 'unidades';
    return '$prefix$quantity $noun';
  }
}

/// Una fila del historial. El tipo dice qué detalle abrir.
class HistoryItem {
  const HistoryItem({
    required this.id,
    required this.kind,
    required this.at,
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.searchText,
    this.amount,
    this.status,
    this.saleId,
    this.salePreview,
    this.purchaseId,
    this.inventory,
    this.liveId,
  });

  final String id;
  final HistoryKind kind;
  final DateTime at;
  final String title;
  final String subtitle;
  final String detail;
  final String searchText;
  final int? amount;
  final String? status;
  final String? saleId;
  final Sale? salePreview;
  final String? purchaseId;
  final InventoryMovementDetail? inventory;
  final String? liveId;

  String? get quantityLabel => inventory?.quantityLabel;
}

bool historyMatchesKind(HistoryItem item, String filter) {
  return switch (filter) {
    'Ventas' => item.kind == HistoryKind.sale,
    'Compras' => item.kind == HistoryKind.purchase,
    'Inventario' => item.kind == HistoryKind.inventory,
    'LIVE' => item.kind == HistoryKind.live,
    _ => true,
  };
}

bool historyMatchesQuery(HistoryItem item, String query) {
  final raw = query.trim().toLowerCase();
  if (raw.isEmpty) return true;
  final compact = raw.replaceAll(' ', '').replaceAll('#', '');
  final haystack = item.searchText.toLowerCase();
  final compactHay = haystack.replaceAll(' ', '').replaceAll('#', '');
  return haystack.contains(raw) || compactHay.contains(compact);
}

bool historyMatchesPeriod(
  HistoryItem item,
  String period,
  DateTime now, {
  DateTime? from,
  DateTime? to,
}) {
  final day = DateTime(item.at.year, item.at.month, item.at.day);
  final today = DateTime(now.year, now.month, now.day);
  return switch (period) {
    'Hoy' => day == today,
    'Esta semana' => _inWeek(day, today),
    'Este mes' => item.at.year == now.year && item.at.month == now.month,
    'Personalizado' => _inRange(day, from, to),
    _ => true,
  };
}

bool _inWeek(DateTime day, DateTime today) {
  final start = today.subtract(Duration(days: today.weekday - 1));
  final end = start.add(const Duration(days: 6));
  return !day.isBefore(start) && !day.isAfter(end);
}

bool _inRange(DateTime day, DateTime? from, DateTime? to) {
  if (from == null || to == null) return true;
  final start = DateTime(from.year, from.month, from.day);
  final end = DateTime(to.year, to.month, to.day);
  final first = start.isAfter(end) ? end : start;
  final last = start.isAfter(end) ? start : end;
  return !day.isBefore(first) && !day.isAfter(last);
}

String historyGroupLabel(DateTime date, DateTime now) {
  const months = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ];
  final day = DateTime(date.year, date.month, date.day);
  final today = DateTime(now.year, now.month, now.day);
  final days = today.difference(day).inDays;
  if (days == 0) return 'Hoy';
  if (days == 1) return 'Ayer';
  return '${date.day} ${months[date.month - 1]}';
}

class HistoryDaySummary {
  const HistoryDaySummary({
    required this.total,
    required this.sales,
    required this.purchases,
    required this.inventory,
  });

  final int total;
  final int sales;
  final int purchases;
  final int inventory;
}

HistoryDaySummary historyDaySummary(List<HistoryItem> items, DateTime now) {
  final today = items.where((item) {
    return item.at.year == now.year &&
        item.at.month == now.month &&
        item.at.day == now.day;
  });
  return HistoryDaySummary(
    total: today.length,
    sales: today.where((item) => item.kind == HistoryKind.sale).length,
    purchases: today.where((item) => item.kind == HistoryKind.purchase).length,
    inventory: today.where((item) => item.kind == HistoryKind.inventory).length,
  );
}

String historyCount(int count, String one, String many) {
  return '$count ${count == 1 ? one : many}';
}
