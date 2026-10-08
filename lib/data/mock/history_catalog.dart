import 'package:flutter/foundation.dart';

import 'package:afyra/data/mock/history_mock.dart';
import 'package:afyra/models/history_item.dart';

class HistoryCatalog extends ChangeNotifier {
  List<HistoryItem>? _override;

  List<HistoryItem> get items => _override ?? buildMockHistory();

  void replace(List<HistoryItem> items) {
    _override = items;
    notifyListeners();
  }

  void reset() {
    _override = null;
    notifyListeners();
  }
}

final historyCatalog = HistoryCatalog();
