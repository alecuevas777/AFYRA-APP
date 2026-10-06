import 'package:afyra/models/purchase.dart';

const suppliers = [
  'Distribuidora Fashion',
  'Importadora Style',
  'Mayorista Boutique',
  'Proveedor Textil Chile',
];

const purchaseVariants = <String, List<String>>{
  'Polera Oversize Negra': ['Negro / S', 'Negro / M', 'Negro / L', 'Blanco / M'],
  'Hoodie Essential': ['Negro / S', 'Negro / M', 'Negro / L'],
  'Jeans Wide Leg': ['Azul / 36', 'Azul / 38', 'Azul / 40'],
  'Crop Top Basic': ['Blanco / S', 'Blanco / M', 'Blanco / L'],
};

const monthCostSnapshot = MonthCostSnapshot(
  merchandise: 324000,
  materials: 38000,
  other: 15000,
);

const materialSupplies = <MaterialSupply>[
  MaterialSupply(name: 'Bolsas medianas', unitCost: 180, stock: 85),
  MaterialSupply(name: 'Stickers', unitCost: 50, stock: 240),
  MaterialSupply(name: 'Etiquetas', unitCost: 90, stock: 120),
  MaterialSupply(name: 'Tarjetas', unitCost: 250, stock: 60),
  MaterialSupply(name: 'Packaging', unitCost: 320, stock: 30),
];

const garmentCosts = <GarmentCost>[
  GarmentCost(
    productName: 'Polera Oversize Negra',
    purchaseCost: 11000,
    associated: [
      ExtraCost(name: 'Packaging', amount: 500),
      ExtraCost(name: 'Sticker', amount: 100),
    ],
    salePrice: 24990,
  ),
  GarmentCost(
    productName: 'Hoodie Essential',
    purchaseCost: 24000,
    associated: [
      ExtraCost(name: 'Packaging', amount: 500),
      ExtraCost(name: 'Sticker', amount: 100),
    ],
    salePrice: 39990,
  ),
];

/// Fechas relativas a hoy para que "Este mes" y "Último mes" sigan teniendo datos.
DateTime _recent(int daysAgo) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final shifted = today.subtract(Duration(days: daysAgo));
  if (shifted.year != today.year || shifted.month != today.month) return today;
  return shifted;
}

DateTime _lastMonth(int day) {
  final now = DateTime.now();
  final end = DateTime(now.year, now.month, 0);
  final safeDay = day.clamp(1, end.day);
  return DateTime(end.year, end.month, safeDay);
}

List<Purchase> buildMockPurchases() {
  return [
    Purchase(
      id: '1048',
      number: 1048,
      supplier: 'Distribuidora Fashion',
      date: _recent(0),
      status: PurchaseStatus.completed,
      lines: const [
        PurchaseLine(
          productName: 'Polera Oversize Negra',
          variantLabel: 'Negro / M',
          quantity: 12,
          unitCost: 11000,
        ),
        PurchaseLine(
          productName: 'Hoodie Essential',
          variantLabel: 'Negro / M',
          quantity: 6,
          unitCost: 24000,
        ),
      ],
      extras: const [
        ExtraCost(name: 'Envío', amount: 18000),
        ExtraCost(name: 'Otros', amount: 30000),
      ],
    ),
    Purchase(
      id: '1047',
      number: 1047,
      supplier: 'Importadora Style',
      date: _recent(2),
      status: PurchaseStatus.completed,
      lines: const [
        PurchaseLine(
          productName: 'Crop Top Basic',
          variantLabel: 'Blanco / M',
          quantity: 10,
          unitCost: 6000,
        ),
        PurchaseLine(
          productName: 'Jeans Wide Leg',
          variantLabel: 'Azul / 38',
          quantity: 5,
          unitCost: 21000,
        ),
      ],
      extras: const [
        ExtraCost(name: 'Envío', amount: 12000),
        ExtraCost(name: 'Bolsas', amount: 8000),
      ],
    ),
    Purchase(
      id: '1046',
      number: 1046,
      supplier: 'Mayorista Boutique',
      date: _recent(4),
      status: PurchaseStatus.completed,
      lines: const [
        PurchaseLine(
          productName: 'Polera Oversize Negra',
          variantLabel: 'Negro / L',
          quantity: 20,
          unitCost: 10500,
        ),
        PurchaseLine(
          productName: 'Hoodie Essential',
          variantLabel: 'Negro / L',
          quantity: 8,
          unitCost: 20000,
        ),
      ],
      extras: const [
        ExtraCost(name: 'Etiquetas', amount: 22000),
        ExtraCost(name: 'Stickers', amount: 8000),
        ExtraCost(name: 'Envío', amount: 12000),
      ],
    ),
    Purchase(
      id: '1045',
      number: 1045,
      supplier: 'Proveedor Textil Chile',
      date: _lastMonth(18),
      status: PurchaseStatus.pending,
      lines: const [
        PurchaseLine(
          productName: 'Polera Oversize Negra',
          variantLabel: 'Negro / S',
          quantity: 4,
          unitCost: 11000,
        ),
        PurchaseLine(
          productName: 'Crop Top Basic',
          variantLabel: 'Blanco / S',
          quantity: 8,
          unitCost: 6000,
        ),
      ],
      extras: const [ExtraCost(name: 'Envío', amount: 8000)],
    ),
    Purchase(
      id: '1044',
      number: 1044,
      supplier: 'Distribuidora Fashion',
      date: _lastMonth(4),
      status: PurchaseStatus.cancelled,
      lines: const [
        PurchaseLine(
          productName: 'Hoodie Essential',
          variantLabel: 'Negro / M',
          quantity: 2,
          unitCost: 24000,
        ),
      ],
      extras: const [],
    ),
  ];
}
