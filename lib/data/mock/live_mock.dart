import 'package:afyra/data/mock/product_catalog.dart';
import 'package:afyra/models/live_session.dart';
import 'package:afyra/models/product.dart';
import 'package:afyra/models/sale.dart';

const liveShopProducts = 48;
const liveShopUnits = 126;

const liveBaseRanking = <String, int>{
  'Polera Oversize Negra': 5,
  'Hoodie Essential': 4,
  'Crop Top Basic': 3,
};

Map<String, int> stockFromProducts(List<Product> products) {
  final stock = <String, int>{};
  for (final product in products) {
    for (final variant in product.variants) {
      stock[liveStockKey(product.id, variant.color, variant.size)] =
          variant.stock;
    }
  }
  return stock;
}

LiveSession buildActiveLive({DateTime? now}) {
  final moment = now ?? DateTime.now();
  return LiveSession(
    id: 'drop',
    name: 'Nuevo Drop',
    description: 'Piezas del drop, en vivo.',
    startedAt: moment.subtract(
      const Duration(hours: 1, minutes: 24, seconds: 36),
    ),
    status: LiveStatus.active,
    baseSales: 18,
    baseUnits: 24,
    baseIncome: 245000,
    baseCost: 158000,
    baseRanking: Map<String, int>.from(liveBaseRanking),
    stock: stockFromProducts(productCatalog.products),
    openingSales: [
      LiveSaleRecord(
        at: moment.subtract(const Duration(minutes: 12)),
        customerName: 'Camila Rojas',
        productName: 'Polera Oversize Negra',
        variantLabel: 'Negro / M',
        quantity: 1,
        unitPrice: 24990,
        estimatedUnitCost: 11600,
        payment: PaymentMethod.transfer,
      ),
      LiveSaleRecord(
        at: moment.subtract(const Duration(minutes: 15)),
        customerName: 'Javiera Soto',
        productName: 'Hoodie Essential',
        variantLabel: 'Negro / M',
        quantity: 1,
        unitPrice: 39990,
        estimatedUnitCost: 24600,
        payment: PaymentMethod.cash,
      ),
      LiveSaleRecord(
        at: moment.subtract(const Duration(minutes: 19)),
        productName: 'Crop Top Basic',
        variantLabel: 'Blanco / M',
        quantity: 1,
        unitPrice: 12990,
        estimatedUnitCost: 6000,
        payment: PaymentMethod.debit,
      ),
    ],
  );
}

LiveSession _pastLive({
  required String id,
  required String name,
  required DateTime startedAt,
  required Duration length,
  required int sales,
  required int units,
  required int income,
  required int cost,
  required List<LiveSaleRecord> salesList,
}) {
  return LiveSession(
    id: id,
    name: name,
    description: '',
    startedAt: startedAt,
    endedAt: startedAt.add(length),
    status: LiveStatus.finished,
    baseSales: sales,
    baseUnits: units,
    baseIncome: income,
    baseCost: cost,
    baseRanking: Map<String, int>.from(liveBaseRanking),
    stock: const {},
    openingSales: salesList,
  );
}

List<LiveSession> buildPastLives() {
  final sunday = DateTime(2026, 10, 5, 19);
  final friday = DateTime(2026, 10, 3, 18, 30);
  return [
    _pastLive(
      id: 'domingo',
      name: 'Live Domingo',
      startedAt: sunday,
      length: const Duration(hours: 1, minutes: 40),
      sales: 32,
      units: 41,
      income: 428000,
      cost: 282000,
      salesList: [
        LiveSaleRecord(
          at: sunday.add(const Duration(minutes: 20)),
          customerName: 'Fernanda Muñoz',
          productName: 'Polera Oversize Negra',
          variantLabel: 'Negro / M',
          quantity: 1,
          unitPrice: 24990,
          estimatedUnitCost: 11600,
          payment: PaymentMethod.transfer,
        ),
        LiveSaleRecord(
          at: sunday.add(const Duration(minutes: 35)),
          customerName: 'Valentina Pérez',
          productName: 'Hoodie Essential',
          variantLabel: 'Negro / L',
          quantity: 1,
          unitPrice: 39990,
          estimatedUnitCost: 24600,
          payment: PaymentMethod.credit,
        ),
      ],
    ),
    _pastLive(
      id: 'viernes',
      name: 'Live Viernes',
      startedAt: friday,
      length: const Duration(minutes: 58),
      sales: 12,
      units: 14,
      income: 186000,
      cost: 122000,
      salesList: [
        LiveSaleRecord(
          at: friday.add(const Duration(minutes: 10)),
          productName: 'Crop Top Basic',
          variantLabel: 'Blanco / S',
          quantity: 1,
          unitPrice: 12990,
          estimatedUnitCost: 6000,
          payment: PaymentMethod.cash,
        ),
      ],
    ),
  ];
}

LiveSession freshLive({
  required String name,
  required String description,
}) {
  final moment = DateTime.now();
  return LiveSession(
    id: 'local-${moment.millisecondsSinceEpoch}',
    name: name,
    description: description,
    startedAt: moment,
    status: LiveStatus.active,
    baseSales: 0,
    baseUnits: 0,
    baseIncome: 0,
    baseCost: 0,
    baseRanking: {},
    stock: stockFromProducts(productCatalog.products),
    openingSales: const [],
  );
}
