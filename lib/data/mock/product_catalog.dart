import 'package:flutter/foundation.dart';

import 'package:afyra/data/mock/product_mock.dart';
import 'package:afyra/models/product.dart';

/// Catálogo en memoria. Se pierde al cerrar la app: no hay base de datos.
class ProductCatalog extends ChangeNotifier {
  ProductCatalog() : _products = [...mockProducts];

  List<Product> _products;

  List<Product> get products => List.unmodifiable(_products);

  int get totalUnits => _products.fold(0, (sum, product) => sum + product.totalStock);

  int get availableCount => _products.where((product) => product.totalStock > 0).length;

  int get lowCount => _products.where((product) => product.level == StockLevel.low).length;

  int get outCount => _products.where((product) => product.level == StockLevel.out).length;

  Product? find(String id) {
    for (final product in _products) {
      if (product.id == id) return product;
    }
    return null;
  }

  void upsert(Product product) {
    final index = _products.indexWhere((item) => item.id == product.id);
    if (index == -1) {
      _products = [product, ..._products];
    } else {
      final next = [..._products];
      next[index] = product;
      _products = next;
    }
    notifyListeners();
  }

  void reset() {
    _products = [...mockProducts];
    notifyListeners();
  }
}

final productCatalog = ProductCatalog();
