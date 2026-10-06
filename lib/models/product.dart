enum StockLevel { ok, low, out }

class ProductVariant {
  const ProductVariant({
    required this.color,
    required this.size,
    required this.stock,
  });

  final String color;
  final String size;
  final int stock;
}

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.sku,
    required this.description,
    required this.cost,
    required this.price,
    required this.variants,
  });

  final String id;
  final String name;
  final String category;
  final String sku;
  final String description;
  final int cost;
  final int price;
  final List<ProductVariant> variants;

  int get totalStock => variants.fold(0, (sum, variant) => sum + variant.stock);

  int get margin => price - cost;

  StockLevel get level {
    if (totalStock <= 0) return StockLevel.out;
    if (totalStock <= 3) return StockLevel.low;
    return StockLevel.ok;
  }

  /// El color con más unidades. Sirve como pista en la tarjeta.
  String get mainColor {
    if (variants.isEmpty) return '';
    final ranked = [...variants]..sort((a, b) => b.stock.compareTo(a.stock));
    return ranked.first.color;
  }

  Map<String, List<ProductVariant>> get variantsByColor {
    final grouped = <String, List<ProductVariant>>{};
    for (final variant in variants) {
      grouped.putIfAbsent(variant.color, () => []).add(variant);
    }
    return grouped;
  }
}

class StockMovement {
  const StockMovement({
    required this.productName,
    required this.variantLabel,
    required this.quantity,
    required this.type,
    required this.when,
  });

  final String productName;
  final String variantLabel;
  final int quantity;
  final String type;
  final String when;
}
