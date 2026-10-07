import 'package:flutter/foundation.dart';

import 'package:afyra/data/mock/customer_mock.dart';
import 'package:afyra/models/customer.dart';

class CustomerCatalog extends ChangeNotifier {
  CustomerCatalog() : _customers = buildMockCustomers();

  List<Customer> _customers;

  List<Customer> get customers => List.unmodifiable(_customers);

  int get total => _customers.length;

  int get newcomers => _customers.where((customer) => customer.isNewOn(DateTime.now())).length;

  int get frequent => _customers.where((customer) => customer.frequent).length;

  int get associatedSales =>
      _customers.fold(0, (sum, customer) => sum + customer.purchaseCount);

  Customer? find(String id) {
    for (final customer in _customers) {
      if (customer.id == id) return customer;
    }
    return null;
  }

  void add(Customer customer) {
    _customers = [customer, ..._customers];
    notifyListeners();
  }

  void update(Customer customer) {
    _customers = [
      for (final current in _customers)
        if (current.id == customer.id) customer else current,
    ];
    notifyListeners();
  }

  void reset() {
    _customers = buildMockCustomers();
    notifyListeners();
  }
}

final customerCatalog = CustomerCatalog();
