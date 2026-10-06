import 'package:flutter/foundation.dart';

import 'package:afyra/data/mock/purchase_mock.dart';
import 'package:afyra/models/purchase.dart';

class PurchaseCatalog extends ChangeNotifier {
  PurchaseCatalog() : _purchases = buildMockPurchases();

  List<Purchase> _purchases;

  List<Purchase> get purchases => List.unmodifiable(_purchases);

  int get completedTotal => _purchases
      .where((purchase) => purchase.status == PurchaseStatus.completed)
      .fold(0, (sum, purchase) => sum + purchase.total);

  int get monthCount {
    final now = DateTime.now();
    return _purchases.where((purchase) {
      return purchase.status != PurchaseStatus.cancelled &&
          purchase.date.year == now.year &&
          purchase.date.month == now.month;
    }).length;
  }

  int get acquiredUnits => _purchases
      .where((purchase) => purchase.status == PurchaseStatus.completed)
      .fold(0, (sum, purchase) => sum + purchase.units);

  Purchase? get latest {
    if (_purchases.isEmpty) return null;
    final sorted = [..._purchases]..sort((a, b) {
      final byDate = b.date.compareTo(a.date);
      if (byDate != 0) return byDate;
      return b.number.compareTo(a.number);
    });
    return sorted.first;
  }

  Purchase? find(String id) {
    for (final purchase in _purchases) {
      if (purchase.id == id) return purchase;
    }
    return null;
  }

  int get nextNumber {
    var highest = 1000;
    for (final purchase in _purchases) {
      if (purchase.number > highest) highest = purchase.number;
    }
    return highest + 1;
  }

  void add(Purchase purchase) {
    _purchases = [purchase, ..._purchases];
    notifyListeners();
  }

  void reset() {
    _purchases = buildMockPurchases();
    notifyListeners();
  }
}

final purchaseCatalog = PurchaseCatalog();
