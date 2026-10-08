import 'package:flutter/foundation.dart';

/// Preferencias de la sesión. Se pierden al cerrar la app.
class SettingsStore extends ChangeNotifier {
  String businessName = 'Ayra';
  String instagram = '@ayra.cl';
  String whatsapp = '+56 9 XXXX XXXX';
  String phone = '+56 9 XXXX XXXX';
  String address = 'Concepción, Chile';

  String userName = 'Alexis';
  String email = 'alexis@example.com';
  String role = 'Administrador';

  bool showCosts = true;
  bool showProfits = true;
  bool confirmActions = true;

  int lowStockThreshold = 5;
  bool lowStockAlerts = true;
  bool notifySales = true;
  bool notifyLiveSummary = true;
  bool notifyReminders = true;

  /// Claro, Oscuro o Automático. La app sigue en claro.
  String appearance = 'Claro';

  void saveBusiness({
    required String name,
    required String instagram,
    required String whatsapp,
    required String phone,
    required String address,
  }) {
    businessName = name;
    this.instagram = instagram;
    this.whatsapp = whatsapp;
    this.phone = phone;
    this.address = address;
    notifyListeners();
  }

  void saveProfile({required String name, required String email}) {
    userName = name;
    this.email = email;
    notifyListeners();
  }

  void setShowCosts(bool value) {
    showCosts = value;
    notifyListeners();
  }

  void setShowProfits(bool value) {
    showProfits = value;
    notifyListeners();
  }

  void setConfirmActions(bool value) {
    confirmActions = value;
    notifyListeners();
  }

  void setLowStockThreshold(int value) {
    lowStockThreshold = value.clamp(1, 20);
    notifyListeners();
  }

  void setLowStockAlerts(bool value) {
    lowStockAlerts = value;
    notifyListeners();
  }

  void setNotifySales(bool value) {
    notifySales = value;
    notifyListeners();
  }

  void setNotifyLiveSummary(bool value) {
    notifyLiveSummary = value;
    notifyListeners();
  }

  void setNotifyReminders(bool value) {
    notifyReminders = value;
    notifyListeners();
  }

  void setAppearance(String value) {
    appearance = value;
    notifyListeners();
  }

  void reset() {
    businessName = 'Ayra';
    instagram = '@ayra.cl';
    whatsapp = '+56 9 XXXX XXXX';
    phone = '+56 9 XXXX XXXX';
    address = 'Concepción, Chile';
    userName = 'Alexis';
    email = 'alexis@example.com';
    role = 'Administrador';
    showCosts = true;
    showProfits = true;
    confirmActions = true;
    lowStockThreshold = 5;
    lowStockAlerts = true;
    notifySales = true;
    notifyLiveSummary = true;
    notifyReminders = true;
    appearance = 'Claro';
    notifyListeners();
  }
}

final settingsStore = SettingsStore();
