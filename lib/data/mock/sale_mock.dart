import 'package:afyra/models/sale.dart';

const saleCustomers = <SaleCustomer>[
  SaleCustomer(name: 'Camila Rojas', phone: '+56 9 1111 2201'),
  SaleCustomer(name: 'Javiera Soto', phone: '+56 9 1111 2202'),
  SaleCustomer(name: 'Fernanda Muñoz', phone: '+56 9 1111 2203'),
  SaleCustomer(name: 'Valentina Pérez', phone: '+56 9 1111 2204'),
];

const todaySalesIncome = 245000;
const todaySalesCount = 18;
const todaySalesProfit = 87500;

int estimatedUnitCost(String productName, int fallback) {
  return switch (productName) {
    'Polera Oversize Negra' => 11600,
    'Hoodie Essential' => 24600,
    'Jeans Wide Leg' => 24000,
    'Crop Top Basic' => 6000,
    'Polera Básica Blanca' => 9000,
    _ => fallback,
  };
}

DateTime _ago({int days = 0, int minutes = 0}) {
  return DateTime.now().subtract(Duration(days: days, minutes: minutes));
}

List<Sale> buildMockSales() {
  return [
    Sale(
      id: '248',
      number: 248,
      customerName: 'Camila Rojas',
      customerPhone: '+56 9 1111 2201',
      at: _ago(minutes: 20),
      status: SaleStatus.completed,
      payment: PaymentMethod.transfer,
      discount: 5000,
      lines: const [
        SaleLine(
          productName: 'Polera Oversize Negra',
          variantLabel: 'Negro / M',
          quantity: 1,
          unitPrice: 24990,
          estimatedUnitCost: 11600,
        ),
        SaleLine(
          productName: 'Hoodie Essential',
          variantLabel: 'Beige / L',
          quantity: 1,
          unitPrice: 39990,
          estimatedUnitCost: 24600,
        ),
      ],
    ),
    Sale(
      id: '247',
      number: 247,
      customerName: 'Javiera Soto',
      customerPhone: '+56 9 1111 2202',
      at: _ago(minutes: 90),
      status: SaleStatus.completed,
      payment: PaymentMethod.cash,
      discount: 0,
      lines: const [
        SaleLine(
          productName: 'Hoodie Essential',
          variantLabel: 'Negro / M',
          quantity: 1,
          unitPrice: 39990,
          estimatedUnitCost: 24600,
        ),
      ],
    ),
    Sale(
      id: '246',
      number: 246,
      at: _ago(minutes: 180),
      status: SaleStatus.completed,
      payment: PaymentMethod.debit,
      discount: 0,
      lines: const [
        SaleLine(
          productName: 'Crop Top Basic',
          variantLabel: 'Blanco / S',
          quantity: 1,
          unitPrice: 12990,
          estimatedUnitCost: 6000,
        ),
      ],
    ),
    Sale(
      id: '245',
      number: 245,
      customerName: 'Fernanda Muñoz',
      customerPhone: '+56 9 1111 2203',
      at: _ago(days: 1, minutes: 40),
      status: SaleStatus.completed,
      payment: PaymentMethod.credit,
      discount: 6498,
      discountNote: '10%',
      lines: const [
        SaleLine(
          productName: 'Polera Oversize Negra',
          variantLabel: 'Negro / M',
          quantity: 1,
          unitPrice: 24990,
          estimatedUnitCost: 11600,
        ),
        SaleLine(
          productName: 'Hoodie Essential',
          variantLabel: 'Negro / L',
          quantity: 1,
          unitPrice: 39990,
          estimatedUnitCost: 24600,
        ),
      ],
    ),
    Sale(
      id: '244',
      number: 244,
      customerName: 'Valentina Pérez',
      customerPhone: '+56 9 1111 2204',
      at: _ago(days: 8),
      status: SaleStatus.pending,
      payment: PaymentMethod.transfer,
      discount: 0,
      lines: const [
        SaleLine(
          productName: 'Jeans Wide Leg',
          variantLabel: 'Azul / 38',
          quantity: 1,
          unitPrice: 42990,
          estimatedUnitCost: 24000,
        ),
      ],
    ),
    Sale(
      id: '243',
      number: 243,
      customerName: 'Camila Rojas',
      customerPhone: '+56 9 1111 2201',
      at: _ago(days: 12),
      status: SaleStatus.cancelled,
      payment: PaymentMethod.other,
      discount: 0,
      lines: const [
        SaleLine(
          productName: 'Polera Básica Blanca',
          variantLabel: 'Blanco / M',
          quantity: 1,
          unitPrice: 18990,
          estimatedUnitCost: 9000,
        ),
      ],
    ),
  ];
}

bool saleOnDay(Sale sale, DateTime day) {
  return sale.at.year == day.year &&
      sale.at.month == day.month &&
      sale.at.day == day.day;
}

bool saleMatchesFilter(Sale sale, String filter, DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  return switch (filter) {
    'Hoy' => saleOnDay(sale, today),
    'Esta semana' => !DateTime(sale.at.year, sale.at.month, sale.at.day).isBefore(
      today.subtract(Duration(days: today.weekday - 1)),
    ),
    'Este mes' => sale.at.year == now.year && sale.at.month == now.month,
    _ => true,
  };
}

bool saleMatchesQuery(Sale sale, String query) {
  final text = query.trim().toLowerCase().replaceAll('#', '');
  if (text.isEmpty) return true;
  final padded = sale.number.toString().padLeft(5, '0');
  final customer = sale.customerLabel.toLowerCase();
  return customer.contains(text) ||
      '${sale.number}'.contains(text) ||
      padded.contains(text);
}
