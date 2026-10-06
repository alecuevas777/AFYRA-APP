enum PurchaseStatus { completed, pending, cancelled }

class PurchaseLine {
  const PurchaseLine({
    required this.productName,
    required this.variantLabel,
    required this.quantity,
    required this.unitCost,
  });

  final String productName;
  final String variantLabel;
  final int quantity;
  final int unitCost;

  int get subtotal => quantity * unitCost;
}

class ExtraCost {
  const ExtraCost({required this.name, required this.amount});

  final String name;
  final int amount;
}

class Purchase {
  const Purchase({
    required this.id,
    required this.number,
    required this.supplier,
    required this.date,
    required this.status,
    required this.lines,
    required this.extras,
  });

  final String id;
  final int number;
  final String supplier;
  final DateTime date;
  final PurchaseStatus status;
  final List<PurchaseLine> lines;
  final List<ExtraCost> extras;

  int get units => lines.fold(0, (sum, line) => sum + line.quantity);

  int get merchandise => lines.fold(0, (sum, line) => sum + line.subtotal);

  int get extrasTotal => extras.fold(0, (sum, cost) => sum + cost.amount);

  int get total => merchandise + extrasTotal;
}

class MaterialSupply {
  const MaterialSupply({
    required this.name,
    required this.unitCost,
    required this.stock,
  });

  final String name;
  final int unitCost;
  final int stock;
}

/// Lectura visual del costo de una prenda. Los montos son mock.
class GarmentCost {
  const GarmentCost({
    required this.productName,
    required this.purchaseCost,
    required this.associated,
    required this.salePrice,
  });

  final String productName;
  final int purchaseCost;
  final List<ExtraCost> associated;
  final int salePrice;

  int get realCost =>
      purchaseCost + associated.fold(0, (sum, cost) => sum + cost.amount);

  int get margin => salePrice - realCost;
}

class MonthCostSnapshot {
  const MonthCostSnapshot({
    required this.merchandise,
    required this.materials,
    required this.other,
  });

  final int merchandise;
  final int materials;
  final int other;

  int get total => merchandise + materials + other;
}
