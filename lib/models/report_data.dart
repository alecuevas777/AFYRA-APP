import 'package:afyra/models/product.dart';

class ReportLine {
  const ReportLine({
    required this.productId,
    required this.name,
    required this.category,
    required this.units,
    required this.unitPrice,
    required this.unitCost,
  });

  final String productId;
  final String name;
  final String category;
  final int units;
  final int unitPrice;
  final int unitCost;

  int get revenue => units * unitPrice;

  int get cost => units * unitCost;

  int get profit => revenue - cost;

  int get unitMargin => unitPrice - unitCost;

  /// Porcentaje de margen sobre el precio, con un decimal.
  double get marginPercent => unitPrice == 0 ? 0 : unitMargin * 100 / unitPrice;
}

class ReportBar {
  const ReportBar({required this.label, required this.amount});

  final String label;
  final int amount;
}

class ReportCustomerStat {
  const ReportCustomerStat({
    required this.customerId,
    required this.name,
    required this.purchases,
    required this.spent,
    required this.lastPurchase,
  });

  final String customerId;
  final String name;
  final int purchases;
  final int spent;
  final DateTime lastPurchase;
}

class ReportLiveStat {
  const ReportLiveStat({
    required this.sessionId,
    required this.name,
    required this.sales,
    required this.units,
    required this.income,
    required this.profit,
  });

  final String sessionId;
  final String name;
  final int sales;
  final int units;
  final int income;
  final int profit;
}

class CategoryShare {
  const CategoryShare({required this.name, required this.percent});

  final String name;
  final int percent;
}

class StockNote {
  const StockNote({required this.productId, required this.name, required this.detail});

  final String productId;
  final String name;
  final String detail;
}

/// Fotografía de un período. Los totales salen de las líneas, no de cifras sueltas.
class ReportData {
  ReportData({
    required this.salesCount,
    required this.lines,
    required this.bars,
    required this.customers,
    required this.lives,
    required this.lowStock,
    required this.noSales,
    required this.previousRevenue,
    required this.previousCost,
    required this.previousSales,
    required this.previousUnits,
    required this.insights,
    this.isEmpty = false,
  });

  final int salesCount;
  final List<ReportLine> lines;
  final List<ReportBar> bars;
  final List<ReportCustomerStat> customers;
  final List<ReportLiveStat> lives;
  final List<StockNote> lowStock;
  final List<StockNote> noSales;
  final int previousRevenue;
  final int previousCost;
  final int previousSales;
  final int previousUnits;
  final List<String> insights;
  final bool isEmpty;

  int get revenue => lines.fold(0, (sum, line) => sum + line.revenue);

  int get cost => lines.fold(0, (sum, line) => sum + line.cost);

  int get estimatedProfit => revenue - cost;

  int get unitsSold => lines.fold(0, (sum, line) => sum + line.units);

  int get averageTicket => salesCount == 0 ? 0 : (revenue / salesCount).round();

  int get previousProfit => previousRevenue - previousCost;

  int get previousTicket =>
      previousSales == 0 ? 0 : (previousRevenue / previousSales).round();

  List<ReportLine> get ranking {
    final sold = lines.where((line) => line.units > 0).toList()
      ..sort((a, b) => b.units.compareTo(a.units));
    return sold;
  }

  List<ReportLine> get bestMargins {
    final sold = lines.where((line) => line.units > 0).toList()
      ..sort((a, b) => b.marginPercent.compareTo(a.marginPercent));
    return sold.take(3).toList();
  }

  List<CategoryShare> get categories {
    if (revenue == 0) return const [];
    final totals = <String, int>{};
    for (final line in lines) {
      if (line.revenue == 0) continue;
      totals.update(line.category, (value) => value + line.revenue, ifAbsent: () => line.revenue);
    }
    final entries = totals.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final percents = <int>[
      for (final entry in entries) (entry.value * 100 / revenue).round(),
    ];
    final drift = 100 - percents.fold<int>(0, (sum, value) => sum + value);
    if (percents.isNotEmpty) percents[0] += drift;
    return [
      for (var i = 0; i < entries.length; i++)
        CategoryShare(name: entries[i].key, percent: percents[i]),
    ];
  }

  int? get liveIncomeShare {
    if (revenue == 0 || lives.isEmpty) return null;
    final income = lives.fold(0, (sum, live) => sum + live.income);
    return (income * 100 / revenue).round();
  }

  double? change(int current, int previous) {
    if (previous == 0) return null;
    return (current - previous) * 100 / previous;
  }

  static ReportData empty() {
    return ReportData(
      salesCount: 0,
      lines: const [],
      bars: const [],
      customers: const [],
      lives: const [],
      lowStock: const [],
      noSales: const [],
      previousRevenue: 0,
      previousCost: 0,
      previousSales: 0,
      previousUnits: 0,
      insights: const [],
      isEmpty: true,
    );
  }
}

List<ReportBar> splitRevenue(int total, List<String> labels, List<int> weights) {
  if (labels.isEmpty) return const [];
  final weightSum = weights.fold(0, (sum, weight) => sum + weight);
  final bars = <ReportBar>[];
  var assigned = 0;
  for (var i = 0; i < labels.length; i++) {
    final amount = i == labels.length - 1
        ? total - assigned
        : (total * weights[i] / weightSum).round();
    assigned += amount;
    bars.add(ReportBar(label: labels[i], amount: amount));
  }
  return bars;
}

List<StockNote> lowStockNotes(List<Product> products) {
  return [
    for (final product in products)
      if (product.totalStock > 0 && product.totalStock <= 3)
        StockNote(
          productId: product.id,
          name: product.name,
          detail: product.totalStock == 1
              ? '1 unidad'
              : '${product.totalStock} unidades',
        )
      else if (product.totalStock == 0)
        StockNote(
          productId: product.id,
          name: product.name,
          detail: 'Sin stock',
        ),
  ];
}

String? liveHeadline(List<ReportLiveStat> lives) {
  if (lives.isEmpty) return null;
  ReportLiveStat pick(int Function(ReportLiveStat live) score) {
    return lives.reduce((best, live) => score(live) > score(best) ? live : best);
  }

  final sales = pick((live) => live.sales);
  final income = pick((live) => live.income);
  final profit = pick((live) => live.profit);
  if (sales.name == income.name && sales.name == profit.name) {
    return '${sales.name} lidera en ventas, ingresos y ganancia.';
  }
  return 'Más ventas: ${sales.name}. Mayor ingreso: ${income.name}. Mayor ganancia: ${profit.name}.';
}
