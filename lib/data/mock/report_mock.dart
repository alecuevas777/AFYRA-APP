import 'package:afyra/core/utils/format.dart';
import 'package:afyra/models/product.dart';
import 'package:afyra/models/report_data.dart';

const oversize = ReportLine(
  productId: 'oversize',
  name: 'Polera Oversize Negra',
  category: 'Poleras',
  units: 0,
  unitPrice: 24990,
  unitCost: 11600,
);

const hoodie = ReportLine(
  productId: 'hoodie',
  name: 'Hoodie Essential',
  category: 'Hoodies',
  units: 0,
  unitPrice: 39990,
  unitCost: 24600,
);

const jeans = ReportLine(
  productId: 'jeans',
  name: 'Jeans Wide Leg',
  category: 'Jeans',
  units: 0,
  unitPrice: 42990,
  unitCost: 24000,
);

const crop = ReportLine(
  productId: 'crop',
  name: 'Crop Top Basic',
  category: 'Tops',
  units: 0,
  unitPrice: 12990,
  unitCost: 6000,
);

const basic = ReportLine(
  productId: 'basic',
  name: 'Polera Básica Blanca',
  category: 'Poleras',
  units: 0,
  unitPrice: 18990,
  unitCost: 9000,
);

ReportLine _units(ReportLine line, int units) {
  return ReportLine(
    productId: line.productId,
    name: line.name,
    category: line.category,
    units: units,
    unitPrice: line.unitPrice,
    unitCost: line.unitCost,
  );
}

/// Los LIVE usan las mismas cifras del modo LIVE, para que el resumen coincida.
const liveDomingo = ReportLiveStat(
  sessionId: 'domingo',
  name: 'Live Domingo',
  sales: 32,
  units: 41,
  income: 428000,
  profit: 146000,
);

const liveViernes = ReportLiveStat(
  sessionId: 'viernes',
  name: 'Live Viernes',
  sales: 12,
  units: 14,
  income: 186000,
  profit: 64000,
);

const livePrimavera = ReportLiveStat(
  sessionId: 'primavera',
  name: 'Especial primavera',
  sales: 21,
  units: 27,
  income: 312000,
  profit: 114000,
);

const liveBoutique = ReportLiveStat(
  sessionId: 'boutique',
  name: 'Live Boutique',
  sales: 9,
  units: 11,
  income: 154000,
  profit: 56000,
);

ReportData reportFor(
  String period, {
  DateTime? from,
  DateTime? to,
  List<Product> products = const [],
  DateTime? now,
}) {
  if (period == 'Personalizado') {
    if (from == null || to == null || !_rangeHasActivity(from, to, now ?? DateTime.now())) {
      return ReportData.empty();
    }
    return _build(_custom, products, const ['Inicio', 'Medio', 'Cierre', 'Extra'], const [2, 3, 4, 2]);
  }

  return switch (period) {
    'Hoy' => _build(_today, products, const ['Mañana', 'Tarde'], const [2, 1]),
    'Esta semana' => _build(
      _week,
      products,
      const ['Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sá', 'Do'],
      const [2, 3, 2, 4, 5, 6, 3],
    ),
    'Últimos 3 meses' => _build(
      _quarter,
      products,
      const ['Ago', 'Sep', 'Oct'],
      const [4, 6, 8],
    ),
    _ => _build(
      _month,
      products,
      const ['Sem 1', 'Sem 2', 'Sem 3', 'Sem 4'],
      const [3, 4, 5, 4],
    ),
  };
}

bool _rangeHasActivity(DateTime from, DateTime to, DateTime now) {
  final start = DateTime(from.year, from.month, from.day);
  final end = DateTime(to.year, to.month, to.day);
  final first = start.isAfter(end) ? end : start;
  final last = start.isAfter(end) ? start : end;
  final shopStart = DateTime(2026, 9, 1);
  final today = DateTime(now.year, now.month, now.day);
  return !last.isBefore(shopStart) && !first.isAfter(today);
}

class _Scene {
  const _Scene({
    required this.lines,
    required this.sales,
    required this.previousRevenue,
    required this.previousCost,
    required this.previousSales,
    required this.previousUnits,
    required this.customers,
    required this.lives,
  });

  final List<ReportLine> lines;
  final int sales;
  final int previousRevenue;
  final int previousCost;
  final int previousSales;
  final int previousUnits;
  final List<ReportCustomerStat> customers;
  final List<ReportLiveStat> lives;
}

final _today = _Scene(
  lines: [
    _units(oversize, 1),
    _units(crop, 1),
    _units(hoodie, 0),
    _units(basic, 0),
    _units(jeans, 0),
  ],
  sales: 2,
  previousRevenue: 24990,
  previousCost: 11600,
  previousSales: 1,
  previousUnits: 1,
  customers: [
    ReportCustomerStat(
      customerId: 'camila',
      name: 'Camila Rojas',
      purchases: 1,
      spent: 24990,
      lastPurchase: DateTime.now().subtract(const Duration(hours: 3)),
    ),
  ],
  lives: const [],
);

final _week = _Scene(
  lines: [
    _units(oversize, 10),
    _units(crop, 16),
    _units(hoodie, 8),
    _units(basic, 11),
    _units(jeans, 0),
  ],
  sales: 38,
  previousRevenue: 820000,
  previousCost: 460000,
  previousSales: 34,
  previousUnits: 40,
  customers: [
    ReportCustomerStat(
      customerId: 'javiera',
      name: 'Javiera Soto',
      purchases: 2,
      spent: 79980,
      lastPurchase: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ReportCustomerStat(
      customerId: 'camila',
      name: 'Camila Rojas',
      purchases: 2,
      spent: 49980,
      lastPurchase: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ],
  lives: const [liveDomingo],
);

final _month = _Scene(
  lines: [
    _units(oversize, 22),
    _units(crop, 20),
    _units(hoodie, 14),
    _units(basic, 12),
    _units(jeans, 0),
  ],
  sales: 54,
  previousRevenue: 1254000,
  previousCost: 690000,
  previousSales: 46,
  previousUnits: 58,
  customers: [
    ReportCustomerStat(
      customerId: 'camila',
      name: 'Camila Rojas',
      purchases: 2,
      spent: 72970,
      lastPurchase: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    ReportCustomerStat(
      customerId: 'javiera',
      name: 'Javiera Soto',
      purchases: 2,
      spent: 79980,
      lastPurchase: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ReportCustomerStat(
      customerId: 'sofia',
      name: 'Sofía Contreras',
      purchases: 1,
      spent: 37980,
      lastPurchase: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ReportCustomerStat(
      customerId: 'fernanda',
      name: 'Fernanda Muñoz',
      purchases: 1,
      spent: 58482,
      lastPurchase: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ],
  lives: const [liveDomingo, liveViernes],
);

final _quarter = _Scene(
  lines: [
    _units(oversize, 40),
    _units(crop, 36),
    _units(hoodie, 24),
    _units(basic, 20),
    _units(jeans, 4),
  ],
  sales: 96,
  previousRevenue: 2400000,
  previousCost: 1300000,
  previousSales: 80,
  previousUnits: 100,
  customers: [
    ReportCustomerStat(
      customerId: 'sofia',
      name: 'Sofía Contreras',
      purchases: 3,
      spent: 96960,
      lastPurchase: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ReportCustomerStat(
      customerId: 'camila',
      name: 'Camila Rojas',
      purchases: 3,
      spent: 97960,
      lastPurchase: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    ReportCustomerStat(
      customerId: 'javiera',
      name: 'Javiera Soto',
      purchases: 3,
      spent: 95970,
      lastPurchase: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ],
  lives: const [liveDomingo, livePrimavera, liveViernes, liveBoutique],
);

final _custom = _Scene(
  lines: [
    _units(oversize, 4),
    _units(crop, 3),
    _units(basic, 2),
    _units(hoodie, 0),
    _units(jeans, 0),
  ],
  sales: 7,
  previousRevenue: 150000,
  previousCost: 80000,
  previousSales: 6,
  previousUnits: 8,
  customers: [
    ReportCustomerStat(
      customerId: 'camila',
      name: 'Camila Rojas',
      purchases: 1,
      spent: 24990,
      lastPurchase: DateTime.now().subtract(const Duration(days: 3)),
    ),
    ReportCustomerStat(
      customerId: 'martina',
      name: 'Martina Fuentes',
      purchases: 1,
      spent: 18990,
      lastPurchase: DateTime.now().subtract(const Duration(days: 4)),
    ),
  ],
  lives: const [],
);

ReportData _build(_Scene scene, List<Product> products, List<String> labels, List<int> weights) {
  final revenue = scene.lines.fold(0, (sum, line) => sum + line.revenue);
  final bars = splitRevenue(revenue, labels, weights);
  final stock = lowStockNotes(products);
  final alreadyFlagged = stock.map((note) => note.productId).toSet();
  final quiet = scene.lines.where((line) => line.units == 0 && !alreadyFlagged.contains(line.productId));
  final data = ReportData(
    salesCount: scene.sales,
    lines: scene.lines,
    bars: bars,
    customers: scene.customers,
    lives: scene.lives,
    lowStock: stock,
    noSales: [
      for (final line in quiet)
        StockNote(productId: line.productId, name: line.name, detail: 'Sin ventas en el período'),
    ],
    previousRevenue: scene.previousRevenue,
    previousCost: scene.previousCost,
    previousSales: scene.previousSales,
    previousUnits: scene.previousUnits,
    insights: const [],
  );
  return ReportData(
    salesCount: data.salesCount,
    lines: data.lines,
    bars: data.bars,
    customers: data.customers,
    lives: data.lives,
    lowStock: data.lowStock,
    noSales: data.noSales,
    previousRevenue: data.previousRevenue,
    previousCost: data.previousCost,
    previousSales: data.previousSales,
    previousUnits: data.previousUnits,
    insights: _insights(data),
  );
}

List<String> _insights(ReportData data) {
  final notes = <String>[];
  final revenueChange = data.change(data.revenue, data.previousRevenue);
  if (revenueChange != null && revenueChange.abs() >= 0.5) {
    final percent = formatPercent(revenueChange.abs()).replaceFirst('+', '');
    notes.add(
      revenueChange > 0
          ? 'Las ventas aumentaron $percent respecto al período anterior.'
          : 'Las ventas bajaron $percent respecto al período anterior.',
    );
  }
  final top = data.ranking.isEmpty ? null : data.ranking.first;
  if (top != null) notes.add('${top.name} es tu producto más vendido.');
  final share = data.liveIncomeShare;
  if (share != null) notes.add('Los LIVE generan el $share% de tus ingresos.');
  final margin = data.bestMargins.isEmpty ? null : data.bestMargins.first;
  if (margin != null) notes.add('${margin.name} tiene uno de los mejores márgenes.');
  for (final line in data.lines.where((line) => line.units == 0)) {
    notes.add('${line.name} no registra ventas durante este período.');
  }
  return notes;
}
