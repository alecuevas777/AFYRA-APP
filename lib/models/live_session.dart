import 'package:afyra/models/sale.dart';

enum LiveStatus { active, finished }

enum LiveStockLevel { ok, low, last, out }

LiveStockLevel liveStockLevel(int stock) {
  if (stock <= 0) return LiveStockLevel.out;
  if (stock == 1) return LiveStockLevel.last;
  if (stock <= 3) return LiveStockLevel.low;
  return LiveStockLevel.ok;
}

String liveStockLabel(int stock) {
  return switch (liveStockLevel(stock)) {
    LiveStockLevel.out => 'Agotado',
    LiveStockLevel.last => 'Última unidad',
    LiveStockLevel.low => 'Stock bajo · $stock',
    LiveStockLevel.ok => 'Stock $stock',
  };
}

String liveStockKey(String productId, String color, String size) {
  return '$productId|$color|$size';
}

class LiveSaleRecord {
  const LiveSaleRecord({
    required this.at,
    required this.productName,
    required this.variantLabel,
    required this.quantity,
    required this.unitPrice,
    required this.estimatedUnitCost,
    required this.payment,
    this.customerName,
  });

  final DateTime at;
  final String productName;
  final String variantLabel;
  final int quantity;
  final int unitPrice;
  final int estimatedUnitCost;
  final PaymentMethod payment;
  final String? customerName;

  int get total => unitPrice * quantity;

  int get estimatedCost => estimatedUnitCost * quantity;

  String get customerLabel =>
      (customerName == null || customerName!.trim().isEmpty)
      ? 'Sin cliente'
      : customerName!;
}

class LiveSession {
  LiveSession({
    required this.id,
    required this.name,
    required this.description,
    required this.startedAt,
    required this.status,
    required this.baseSales,
    required this.baseUnits,
    required this.baseIncome,
    required this.baseCost,
    required this.baseRanking,
    required this.stock,
    required this.openingSales,
    this.endedAt,
    List<LiveSaleRecord>? sales,
  }) : sales = sales ?? <LiveSaleRecord>[];

  final String id;
  final String name;
  final String description;
  final DateTime startedAt;
  LiveStatus status;
  DateTime? endedAt;
  final int baseSales;
  final int baseUnits;
  final int baseIncome;
  final int baseCost;
  final Map<String, int> baseRanking;
  final Map<String, int> stock;
  final List<LiveSaleRecord> openingSales;
  final List<LiveSaleRecord> sales;

  Duration get elapsed => (endedAt ?? DateTime.now()).difference(startedAt);

  int get salesCount => baseSales + sales.length;

  int get unitsSold =>
      baseUnits + sales.fold(0, (sum, sale) => sum + sale.quantity);

  int get income => baseIncome + sales.fold(0, (sum, sale) => sum + sale.total);

  int get estimatedCost =>
      baseCost + sales.fold(0, (sum, sale) => sum + sale.estimatedCost);

  int get profit => income - estimatedCost;

  int get averageTicket => salesCount == 0 ? 0 : (income / salesCount).round();

  List<LiveSaleRecord> get visibleSales => [...sales, ...openingSales];

  int stockOf(String productId, String color, String size) {
    return stock[liveStockKey(productId, color, size)] ?? 0;
  }

  Map<String, int> ranking() {
    final totals = Map<String, int>.from(baseRanking);
    for (final sale in sales) {
      totals.update(
        sale.productName,
        (units) => units + sale.quantity,
        ifAbsent: () => sale.quantity,
      );
    }
    return totals;
  }

  String get featuredName {
    final totals = ranking();
    if (totals.isEmpty) return '';
    final ranked = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return ranked.first.key;
  }

  int get featuredUnits {
    if (featuredName.isEmpty) return 0;
    return ranking()[featuredName] ?? 0;
  }
}
