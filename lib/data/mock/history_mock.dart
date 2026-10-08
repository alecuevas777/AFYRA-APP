import 'package:afyra/data/mock/live_catalog.dart';
import 'package:afyra/data/mock/purchase_catalog.dart';
import 'package:afyra/data/mock/sale_catalog.dart';
import 'package:afyra/models/history_item.dart';
import 'package:afyra/models/live_session.dart';
import 'package:afyra/models/purchase.dart';
import 'package:afyra/models/sale.dart';

/// Arma el historial con lo que ya existe en ventas, compras y LIVE,
/// y agrega movimientos y ventas de ejemplo que no alteran esos catálogos.
List<HistoryItem> buildMockHistory() {
  final items = <HistoryItem>[
    for (final sale in saleCatalog.sales) _fromSale(sale, inCatalog: true),
    ..._extraSales(),
    for (final purchase in purchaseCatalog.purchases) _fromPurchase(purchase),
    ..._movements(),
    for (final session in liveCatalog.history) _fromLive(session),
  ];
  items.sort((a, b) => b.at.compareTo(a.at));
  return items;
}

HistoryItem _fromSale(Sale sale, {required bool inCatalog}) {
  final products = sale.lines.map((line) => line.productName).join(' ');
  final status = switch (sale.status) {
    SaleStatus.completed => 'Completada',
    SaleStatus.pending => 'Pendiente',
    SaleStatus.cancelled => 'Cancelada',
  };
  return HistoryItem(
    id: 'sale-${sale.id}',
    kind: HistoryKind.sale,
    at: sale.at,
    title: 'Venta ${sale.numberLabel}',
    subtitle: sale.customerLabel,
    detail: sale.piecesLabel,
    amount: sale.total,
    status: status,
    searchText:
        'venta ${sale.numberLabel} ${sale.number} ${sale.customerLabel} $products',
    saleId: inCatalog ? sale.id : null,
    salePreview: inCatalog ? null : sale,
  );
}

HistoryItem _fromPurchase(Purchase purchase) {
  final products = purchase.lines.map((line) => line.productName).join(' ');
  final pieces = purchase.units == 1 ? '1 producto' : '${purchase.units} productos';
  final status = switch (purchase.status) {
    PurchaseStatus.completed => 'Completada',
    PurchaseStatus.pending => 'Pendiente',
    PurchaseStatus.cancelled => 'Cancelada',
  };
  return HistoryItem(
    id: 'purchase-${purchase.id}',
    kind: HistoryKind.purchase,
    at: DateTime(purchase.date.year, purchase.date.month, purchase.date.day, 11, 20),
    title: 'Compra #${purchase.number}',
    subtitle: purchase.supplier,
    detail: pieces,
    amount: purchase.total,
    status: status,
    searchText:
        'compra ${purchase.number} ${purchase.supplier} $products',
    purchaseId: purchase.id,
  );
}

HistoryItem _fromLive(LiveSession session) {
  final ended = session.endedAt ?? session.startedAt;
  return HistoryItem(
    id: 'live-${session.id}',
    kind: HistoryKind.live,
    at: ended,
    title: session.name,
    subtitle: '${session.salesCount} ventas · ${session.unitsSold} productos',
    detail: session.status == LiveStatus.finished ? 'Finalizado' : 'En curso',
    amount: session.income,
    status: 'Finalizado',
    searchText: '${session.name} live',
    liveId: session.id,
  );
}

List<HistoryItem> _extraSales() {
  final now = DateTime.now();
  Sale sale({
    required String id,
    required int number,
    required String customer,
    required String phone,
    required DateTime at,
    required List<SaleLine> lines,
  }) {
    return Sale(
      id: id,
      number: number,
      customerName: customer,
      customerPhone: phone,
      at: at,
      status: SaleStatus.completed,
      payment: PaymentMethod.transfer,
      discount: 0,
      lines: lines,
    );
  }

  const crop = SaleLine(
    productName: 'Crop Top Basic',
    variantLabel: 'Blanco / M',
    quantity: 1,
    unitPrice: 12990,
    estimatedUnitCost: 6000,
  );
  const polera = SaleLine(
    productName: 'Polera Oversize Negra',
    variantLabel: 'Negro / M',
    quantity: 1,
    unitPrice: 24990,
    estimatedUnitCost: 11600,
  );
  const jeans = SaleLine(
    productName: 'Jeans Wide Leg',
    variantLabel: 'Azul / 38',
    quantity: 1,
    unitPrice: 42990,
    estimatedUnitCost: 24000,
  );

  return [
    _fromSale(
      sale(
        id: 'h-242',
        number: 242,
        customer: 'Sofía Contreras',
        phone: '+56 9 1111 2205',
        at: now.subtract(const Duration(hours: 5)),
        lines: const [crop, polera],
      ),
      inCatalog: false,
    ),
    _fromSale(
      sale(
        id: 'h-241',
        number: 241,
        customer: 'Martina Fuentes',
        phone: '+56 9 1111 2206',
        at: now.subtract(const Duration(days: 3, hours: 2)),
        lines: const [polera],
      ),
      inCatalog: false,
    ),
    _fromSale(
      sale(
        id: 'h-240',
        number: 240,
        customer: 'Javiera Soto',
        phone: '+56 9 1111 2202',
        at: now.subtract(const Duration(days: 6, hours: 3)),
        lines: const [jeans],
      ),
      inCatalog: false,
    ),
  ];
}

List<HistoryItem> _movements() {
  HistoryItem movement({
    required String id,
    required DateTime at,
    required String title,
    required InventoryMovementDetail detail,
  }) {
    return HistoryItem(
      id: id,
      kind: HistoryKind.inventory,
      at: at,
      title: title,
      subtitle: detail.productName,
      detail: detail.reason,
      searchText:
          '$title ${detail.productName} ${detail.variantLabel} ${detail.reason}',
      inventory: detail,
    );
  }

  final now = DateTime.now();
  DateTime at(int days, int hour, int minute) {
    final day = DateTime(now.year, now.month, now.day).subtract(Duration(days: days));
    return DateTime(day.year, day.month, day.day, hour, minute);
  }

  return [
    movement(
      id: 'mov-1',
      at: at(0, 10, 45),
      title: 'Entrada de stock',
      detail: const InventoryMovementDetail(
        productName: 'Polera Oversize Negra',
        variantLabel: 'Negro / M',
        quantity: 12,
        stockBefore: 4,
        stockAfter: 16,
        reason: 'Compra #1048',
      ),
    ),
    movement(
      id: 'mov-2',
      at: at(0, 15, 10),
      title: 'Salida de stock',
      detail: const InventoryMovementDetail(
        productName: 'Polera Oversize Negra',
        variantLabel: 'Negro / M',
        quantity: -1,
        stockBefore: 5,
        stockAfter: 4,
        reason: 'Venta #00248',
      ),
    ),
    movement(
      id: 'mov-3',
      at: at(1, 18, 5),
      title: 'Ajuste de stock',
      detail: const InventoryMovementDetail(
        productName: 'Hoodie Essential',
        variantLabel: 'Negro / M',
        quantity: -1,
        stockBefore: 2,
        stockAfter: 1,
        reason: 'Ajuste de inventario',
      ),
    ),
    movement(
      id: 'mov-4',
      at: at(2, 16, 40),
      title: 'Entrada de stock',
      detail: const InventoryMovementDetail(
        productName: 'Crop Top Basic',
        variantLabel: 'Blanco / M',
        quantity: 10,
        stockBefore: 2,
        stockAfter: 12,
        reason: 'Compra #1047',
      ),
    ),
    movement(
      id: 'mov-5',
      at: at(3, 13, 20),
      title: 'Salida de stock',
      detail: const InventoryMovementDetail(
        productName: 'Crop Top Basic',
        variantLabel: 'Blanco / M',
        quantity: -1,
        stockBefore: 12,
        stockAfter: 11,
        reason: 'Venta #00242',
      ),
    ),
    movement(
      id: 'mov-6',
      at: at(4, 11, 10),
      title: 'Entrada de stock',
      detail: const InventoryMovementDetail(
        productName: 'Jeans Wide Leg',
        variantLabel: 'Azul / 38',
        quantity: 5,
        stockBefore: 0,
        stockAfter: 5,
        reason: 'Compra #1046',
      ),
    ),
    movement(
      id: 'mov-7',
      at: at(6, 16, 40),
      title: 'Entrada de stock',
      detail: const InventoryMovementDetail(
        productName: 'Polera Básica Blanca',
        variantLabel: 'Blanco / S',
        quantity: 6,
        stockBefore: 1,
        stockAfter: 7,
        reason: 'Compra #1045',
      ),
    ),
    movement(
      id: 'mov-8',
      at: at(9, 20, 18),
      title: 'Salida de stock',
      detail: const InventoryMovementDetail(
        productName: 'Jeans Wide Leg',
        variantLabel: 'Azul / 38',
        quantity: -1,
        stockBefore: 1,
        stockAfter: 0,
        reason: 'Venta #00240',
      ),
    ),
    movement(
      id: 'mov-9',
      at: at(15, 9, 30),
      title: 'Entrada de stock',
      detail: const InventoryMovementDetail(
        productName: 'Hoodie Essential',
        variantLabel: 'Negro / L',
        quantity: 8,
        stockBefore: 1,
        stockAfter: 9,
        reason: 'Compra #1046',
      ),
    ),
  ];
}
