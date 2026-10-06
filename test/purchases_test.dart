import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:afyra/core/app.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/data/mock/purchase_catalog.dart';
import 'package:afyra/data/mock/purchase_mock.dart';
import 'package:afyra/widgets/purchase_card.dart';

void main() {
  setUp(purchaseCatalog.reset);

  Future<void> openPurchases(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AfyraApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Compra'));
    await tester.pumpAndSettle();
  }

  test('la compra 1048 cuadra unidades, extras y total', () {
    final purchase = purchaseCatalog.purchases.firstWhere(
      (item) => item.number == 1048,
    );

    expect(purchase.units, 18);
    expect(purchase.merchandise, 276000);
    expect(purchase.extrasTotal, 48000);
    expect(purchase.total, 324000);
    expect(monthCostSnapshot.total, 377000);
    expect(garmentCosts.first.realCost, 11600);
    expect(garmentCosts.first.margin, 13390);
  });

  testWidgets('el historial muestra la compra y filtra el mes anterior', (
    tester,
  ) async {
    await openPurchases(tester);

    expect(find.text('Total comprado'), findsOneWidget);
    expect(find.text(formatClp(324000)), findsWidgets);
    expect(find.text('#1048'), findsWidgets);

    await tester.scrollUntilVisible(find.text('Último mes'), 200);
    await tester.tap(find.text('Último mes'));
    await tester.pumpAndSettle();

    expect(find.text('Proveedor Textil Chile'), findsOneWidget);
    expect(find.text('#1046'), findsNothing);
  });

  testWidgets('mayor costo ordena primero la compra más alta', (tester) async {
    await openPurchases(tester);
    await tester.scrollUntilVisible(find.text('Mayor costo'), 200);
    await tester.tap(find.text('Mayor costo'));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(PurchaseCard).first,
        matching: find.text('#1046'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('el detalle muestra prendas y el total', (tester) async {
    await openPurchases(tester);
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('purchase-1048')),
      400,
      scrollable: find.byType(Scrollable).hitTestable(),
    );
    await tester.tap(find.byKey(const ValueKey('purchase-1048')));
    await tester.pumpAndSettle();

    expect(find.text('Compra #1048'), findsOneWidget);
    expect(find.text('Negro / M'), findsWidgets);
    expect(find.text('Total'), findsOneWidget);
    expect(find.text(formatClp(324000)), findsWidgets);
  });

  testWidgets('confirmar una compra la deja en el historial de la sesión', (
    tester,
  ) async {
    await openPurchases(tester);
    await tester.tap(find.byTooltip('Nueva compra'));
    await tester.pumpAndSettle();

    expect(find.text('Nueva compra'), findsOneWidget);
    expect(find.text('Distribuidora Fashion'), findsWidgets);
    await tester.drag(find.byType(ListView).hitTestable(), const Offset(0, -900));
    await tester.pumpAndSettle();
    expect(find.text('Agregar costo'), findsOneWidget);
    await tester.tap(find.byKey(const Key('confirm-purchase')));
    await tester.pumpAndSettle();

    expect(find.text('Compra lista en esta sesión.'), findsOneWidget);
    expect(find.text('#1049'), findsOneWidget);
  });

  testWidgets('materiales y costo real se abren desde compras', (tester) async {
    await openPurchases(tester);
    final materials = find.widgetWithText(TextButton, 'Materiales');
    await tester.scrollUntilVisible(materials, 200);
    await tester.tap(materials);
    await tester.pumpAndSettle();

    expect(find.text('Bolsas medianas'), findsOneWidget);
    expect(find.text('Stock 85'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Costo real'), 200);
    await tester.tap(find.text('Costo real'));
    await tester.pumpAndSettle();

    expect(find.text(formatClp(11600)), findsOneWidget);
    expect(find.text(formatClp(13390)), findsOneWidget);
  });
}
