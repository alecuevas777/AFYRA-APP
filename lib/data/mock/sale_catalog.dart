import 'package:flutter/foundation.dart';

import 'package:afyra/data/mock/sale_mock.dart';
import 'package:afyra/models/sale.dart';

class SaleCatalog extends ChangeNotifier {
  SaleCatalog() : _sales = buildMockSales();

  List<Sale> _sales;
  int _addedIncome = 0;
  int _addedCount = 0;
  int _addedProfit = 0;

  List<Sale> get sales => List.unmodifiable(_sales);

  int get todayIncome => todaySalesIncome + _addedIncome;

  int get todayCount => todaySalesCount + _addedCount;

  int get todayProfit => todaySalesProfit + _addedProfit;

  Sale? find(String id) {
    for (final sale in _sales) {
      if (sale.id == id) return sale;
    }
    return null;
  }

  int get nextNumber {
    var highest = 200;
    for (final sale in _sales) {
      if (sale.number > highest) highest = sale.number;
    }
    return highest + 1;
  }

  void add(Sale sale) {
    _sales = [sale, ..._sales];
    _addedIncome += sale.total;
    _addedCount += 1;
    _addedProfit += sale.estimatedProfit;
    notifyListeners();
  }

  void reset() {
    _sales = buildMockSales();
    _addedIncome = 0;
    _addedCount = 0;
    _addedProfit = 0;
    notifyListeners();
  }
}

final saleCatalog = SaleCatalog();
