import 'package:afyra/models/dashboard_data.dart';

/// Datos ficticios para dibujar el Dashboard. No se guardan en ningún lado.
const dashboardMock = DashboardData(
  income: 245000,
  profit: 87500,
  salesCount: 6,
  productsSold: 18,
  lowStock: [
    StockItem(name: 'Polera Oversize Negra', detail: 'M · Negro', units: 2),
    StockItem(name: 'Jeans Wide Leg', detail: '38', units: 1),
    StockItem(name: 'Crop Top Basic', detail: 'S · Blanco', units: 3),
  ],
  recentSales: [
    RecentSale(
      product: 'Polera Básica Blanca',
      customer: 'Camila',
      time: '21:14',
      amount: 18990,
    ),
    RecentSale(
      product: 'Hoodie Essential',
      customer: 'Javiera',
      time: '20:02',
      amount: 39990,
    ),
    RecentSale(
      product: 'Crop Top Basic',
      customer: 'Fernanda',
      time: '19:41',
      amount: 12990,
    ),
    RecentSale(
      product: 'Jeans Wide Leg',
      customer: 'Valentina',
      time: '18:55',
      amount: 42990,
    ),
  ],
  lastLive: LiveSnapshot(
    status: 'Finalizado',
    when: 'Hoy · 19:10',
    sales: 12,
    income: 186000,
    productsSold: 14,
  ),
);
