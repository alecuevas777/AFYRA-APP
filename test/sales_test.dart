import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:afyra/core/app.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/data/mock/sale_catalog.dart';
import 'package:afyra/data/mock/sale_mock.dart';
import 'package:afyra/models/sale.dart';

void main() {
  setUp(saleCatalog.reset);

  Future<void> openSales(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AfyraApp());
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Ventas'),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('la venta 248 descuenta y separa costo de ganancia', () {
    final sale = saleCatalog.sales.firstWhere((item) => item.number == 248);

    expect(sale.subtotal, 64980);
    expect(sale.discount, 5000);
    expect(sale.total, 59980);
    expect(sale.estimatedCost, 36200);
    expect(sale.estimatedProfit, 23780);
    expect(sale.customerLabel, 'Camila Rojas');
    expect(
      discountAmount(subtotal: 64980, raw: 10, percent: true),
      6498,
    );
  });

  test('hoy no incluye una venta de hace varios días', () {
    final now = DateTime.now();
    final today = saleCatalog.sales.where(
      (sale) => saleMatchesFilter(sale, 'Hoy', now),
    );

    expect(today.any((sale) => sale.number == 248), isTrue);
    expect(today.any((sale) => sale.number == 244), isFalse);
  });

  testWidgets('el historial busca por número y filtra el día', (tester) async {
    await openSales(tester);

    expect(find.text('Ventas de hoy'), findsOneWidget);
    expect(find.text(formatClp(245000)), findsOneWidget);
    expect(find.text('Camila Rojas'), findsWidgets);

    await tester.enterText(find.byType(TextField), '243');
    await tester.pumpAndSettle();
    expect(find.textContaining('#00243'), findsOneWidget);
    expect(find.textContaining('#00248'), findsNothing);

    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hoy'));
    await tester.pumpAndSettle();
    expect(find.textContaining('#00248'), findsWidgets);
    expect(find.text('Valentina Pérez'), findsNothing);
  });

  testWidgets('una venta nueva queda registrada en la sesión', (tester) async {
    await openSales(tester);
    await tester.tap(find.byTooltip('Nueva venta'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('add-sale-line')));
    await tester.pumpAndSettle();
    expect(find.text('Polera Oversize Negra'), findsWidgets);

    await tester.tap(find.byTooltip('Subir cantidad'));
    await tester.pumpAndSettle();
    expect(find.text('2'), findsWidgets);

    await tester.tap(find.text('Quitar'));
    await tester.pumpAndSettle();
    expect(find.text('Todavía no hay prendas en esta venta.'), findsOneWidget);

    await tester.tap(find.byKey(const Key('add-sale-line')));
    await tester.pumpAndSettle();

    Future<void> reveal(Finder finder) async {
      for (var i = 0; i < 8 && finder.evaluate().isEmpty; i++) {
        await tester.drag(find.byType(ListView).hitTestable(), const Offset(0, -450));
        await tester.pumpAndSettle();
      }
      await tester.ensureVisible(finder);
    }

    final customer = find.text('Camila Rojas');
    await reveal(customer);
    await tester.tap(customer);
    await tester.pumpAndSettle();
    final cash = find.text('Efectivo');
    await reveal(cash);
    await tester.tap(cash);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm-sale')));
    await tester.pumpAndSettle();

    expect(find.text('Venta registrada'), findsOneWidget);
    expect(find.text('Camila Rojas'), findsOneWidget);
    await tester.tap(find.text('Ver venta'));
    await tester.pumpAndSettle();
    expect(find.text('Venta #00249'), findsOneWidget);
    expect(find.text('Efectivo'), findsOneWidget);
  });
}
