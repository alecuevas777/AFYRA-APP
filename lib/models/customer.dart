import 'package:afyra/models/sale.dart';

class Customer {
  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.whatsapp,
    required this.joinedAt,
    this.instagram,
    this.address,
    this.notes,
    List<Sale>? purchases,
  }) : purchases = purchases ?? <Sale>[];

  final String id;
  final String name;
  final String phone;
  final String whatsapp;
  final DateTime joinedAt;
  final String? instagram;
  final String? address;
  final String? notes;
  final List<Sale> purchases;

  List<Sale> get history {
    final copy = [...purchases]..sort((a, b) => b.at.compareTo(a.at));
    return copy;
  }

  int get purchaseCount => purchases.where(_counts).length;

  int get completedCount =>
      purchases.where((sale) => sale.status == SaleStatus.completed).length;

  int get spent => purchases
      .where((sale) => sale.status == SaleStatus.completed)
      .fold(0, (sum, sale) => sum + sale.total);

  int get averageTicket => completedCount == 0 ? 0 : (spent / completedCount).round();

  DateTime? get lastPurchaseAt {
    final counted = purchases.where(_counts).toList();
    if (counted.isEmpty) return null;
    counted.sort((a, b) => b.at.compareTo(a.at));
    return counted.first.at;
  }

  bool get frequent => purchaseCount >= 3;

  bool recentOn(DateTime now) {
    final last = lastPurchaseAt;
    if (last == null) return false;
    return now.difference(last).inDays <= 14;
  }

  bool isNewOn(DateTime now) => now.difference(joinedAt).inDays <= 30;

  String get initials {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
  }

  bool _counts(Sale sale) => sale.status != SaleStatus.cancelled;
}

bool customerMatchesFilter(Customer customer, String filter, DateTime now) {
  return switch (filter) {
    'Recientes' => customer.recentOn(now),
    'Frecuentes' => customer.frequent,
    'Sin compras' => customer.purchaseCount == 0,
    _ => true,
  };
}

bool customerMatchesQuery(Customer customer, String query) {
  final raw = query.trim().toLowerCase();
  if (raw.isEmpty) return true;
  final compact = raw.replaceAll(' ', '');
  final phone = customer.phone.replaceAll(' ', '').toLowerCase();
  final whatsapp = customer.whatsapp.replaceAll(' ', '').toLowerCase();
  return customer.name.toLowerCase().contains(raw) ||
      phone.contains(compact) ||
      whatsapp.contains(compact);
}

String purchaseNames(Sale sale) {
  final names = sale.lines.map((line) => line.productName).toList();
  if (names.isEmpty) return 'Sin prendas';
  if (names.length <= 2) return names.join(' + ');
  return '${names.first} + ${names.length - 1} más';
}
