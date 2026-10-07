import 'package:flutter/foundation.dart';

import 'package:afyra/data/mock/live_mock.dart';
import 'package:afyra/data/mock/sale_mock.dart';
import 'package:afyra/models/live_session.dart';
import 'package:afyra/models/product.dart';
import 'package:afyra/models/sale.dart';

class LiveCatalog extends ChangeNotifier {
  LiveCatalog() {
    _reset();
  }

  LiveSession? _active;
  List<LiveSession> _history = [];

  LiveSession? get active => _active;

  List<LiveSession> get history => List.unmodifiable(_history);

  LiveSession? find(String id) {
    if (_active?.id == id) return _active;
    for (final session in _history) {
      if (session.id == id) return session;
    }
    return null;
  }

  void start({required String name, String description = ''}) {
    _active = freshLive(name: name.trim(), description: description.trim());
    notifyListeners();
  }

  LiveSaleRecord? sell({
    required Product product,
    required String color,
    required String size,
    required int quantity,
    required PaymentMethod payment,
    String? customerName,
  }) {
    final session = _active;
    if (session == null || quantity <= 0) return null;
    final key = liveStockKey(product.id, color, size);
    final available = session.stock[key] ?? 0;
    if (quantity > available) return null;

    session.stock[key] = available - quantity;
    final record = LiveSaleRecord(
      at: DateTime.now(),
      customerName: customerName,
      productName: product.name,
      variantLabel: '$color / $size',
      quantity: quantity,
      unitPrice: product.price,
      estimatedUnitCost: estimatedUnitCost(product.name, product.cost),
      payment: payment,
    );
    session.sales.insert(0, record);
    notifyListeners();
    return record;
  }

  LiveSession? finish() {
    final session = _active;
    if (session == null) return null;
    session.status = LiveStatus.finished;
    session.endedAt = DateTime.now();
    _history = [session, ..._history];
    _active = null;
    notifyListeners();
    return session;
  }

  void reset() {
    _reset();
    notifyListeners();
  }

  void _reset() {
    _active = buildActiveLive();
    _history = buildPastLives();
  }
}

final liveCatalog = LiveCatalog();
