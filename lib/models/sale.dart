enum SaleStatus { completed, pending, cancelled }

enum PaymentMethod {
  transfer('Transferencia'),
  cash('Efectivo'),
  debit('Débito'),
  credit('Crédito'),
  other('Otro');

  const PaymentMethod(this.label);

  final String label;
}

class SaleLine {
  const SaleLine({
    required this.productName,
    required this.variantLabel,
    required this.quantity,
    required this.unitPrice,
    required this.estimatedUnitCost,
  });

  final String productName;
  final String variantLabel;
  final int quantity;
  final int unitPrice;
  final int estimatedUnitCost;

  int get subtotal => quantity * unitPrice;

  int get estimatedCost => quantity * estimatedUnitCost;

  int get estimatedMargin => subtotal - estimatedCost;

  SaleLine copyWith({int? quantity}) {
    return SaleLine(
      productName: productName,
      variantLabel: variantLabel,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice,
      estimatedUnitCost: estimatedUnitCost,
    );
  }
}

class SaleCustomer {
  const SaleCustomer({required this.name, required this.phone});

  final String name;
  final String phone;
}

class Sale {
  const Sale({
    required this.id,
    required this.number,
    required this.at,
    required this.status,
    required this.payment,
    required this.lines,
    required this.discount,
    this.customerName,
    this.customerPhone,
    this.discountNote,
  });

  final String id;
  final int number;
  final DateTime at;
  final SaleStatus status;
  final PaymentMethod payment;
  final List<SaleLine> lines;
  final int discount;
  final String? customerName;
  final String? customerPhone;

  /// Texto corto cuando el descuento es un porcentaje, por ejemplo "10%".
  final String? discountNote;

  int get units => lines.fold(0, (sum, line) => sum + line.quantity);

  int get subtotal => lines.fold(0, (sum, line) => sum + line.subtotal);

  int get total => subtotal - discount;

  int get estimatedCost => lines.fold(0, (sum, line) => sum + line.estimatedCost);

  int get estimatedProfit => total - estimatedCost;

  String get numberLabel => '#${number.toString().padLeft(5, '0')}';

  String get customerLabel =>
      (customerName == null || customerName!.trim().isEmpty)
      ? 'Sin cliente'
      : customerName!;

  String get piecesLabel => units == 1 ? '1 producto' : '$units productos';
}

/// Descuento de pantalla. No es un motor de precios: solo arma el monto visible.
int discountAmount({
  required int subtotal,
  required int raw,
  required bool percent,
}) {
  if (subtotal <= 0 || raw <= 0) return 0;
  if (percent) {
    final safe = raw > 100 ? 100 : raw;
    final amount = (subtotal * safe / 100).round();
    return amount > subtotal ? subtotal : amount;
  }
  return raw > subtotal ? subtotal : raw;
}
