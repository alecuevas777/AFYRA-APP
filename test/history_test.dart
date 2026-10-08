import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:afyra/core/app.dart';
import 'package:afyra/data/mock/history_catalog.dart';
import 'package:afyra/data/mock/history_mock.dart';
import 'package:afyra/models/history_item.dart';

void main() {
  setUp(historyCatalog.reset);

  test('reúne ventas, compras, stock y LIVE, y los filtra', () {
    final now = DateTime.now();
    final items = buildMockHistory();
    expect(
      items.where((item) => item.kind == HistoryKind.sale).length,
      greaterThanOrEqualTo(8),
    );
    expect(
      items.where((item) => item.kind == HistoryKind.purchase).length,
      greaterThanOrEqualTo(4),
    );
    expect(
      items.where((item) => item.kind == HistoryKind.inventory).length,
      greaterThanOrEqualTo(8),
    );
    expect(
      items.where((item) => item.kind == HistoryKind.live).length,
      greaterThanOrEqualTo(3),
    );
    expect(items.first.at.isBefore(items.last.at), isFalse);

    expect(
      items.where((item) => historyMatchesQuery(item, 'Camila')).length,
      greaterThan(0),
    );
    expect(
      items.where((item) => historyMatchesQuery(item, '1048')).length,
      greaterThan(0),
    );
    expect(
      items.where((item) => historyMatchesQuery(item, 'Polera Oversize')).length,
      greaterThan(0),
    );
    expect(
      items.where((item) => historyMatchesQuery(item, 'Distribuidora')).length,
      greaterThan(0),
    );
    expect(
      items.where((item) => historyMatchesQuery(item, 'Live Domingo')).length,
      1,
    );
    expect(items.where((item) => historyMatchesQuery(item, 'zzzz')).isEmpty, isTrue);

    final sales = items.where((item) => historyMatchesKind(item, 'Ventas'));
    expect(sales.every((item) => item.kind == HistoryKind.sale), isTrue);
    final today = items.where((item) => historyMatchesPeriod(item, 'Hoy', now));
    expect(today.any((item) => item.title == 'Venta #00248'), isTrue);
    expect(historyGroupLabel(now, now), 'Hoy');
    expect(historyDaySummary(items, now).sales, greaterThan(0));
  });

  testWidgets('el historial busca, filtra y abre cada detalle', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AfyraApp());
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(of: find.byType(NavigationBar), matching: find.text('Más')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Historial'));
    await tester.pumpAndSettle();

    expect(find.text('Revisa la actividad de tu negocio.'), findsOneWidget);
    expect(find.text('Venta #00248'), findsWidgets);
    expect(tester.takeException(), isNull);

    await tester.enterText(find.byType(TextField), 'zzzz');
    await tester.pumpAndSettle();
    expect(find.text('No encontramos actividad'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Camila');
    await tester.pumpAndSettle();
    expect(find.text('Camila Rojas'), findsWidgets);
    expect(find.text('Distribuidora Fashion'), findsNothing);

    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Ventas'));
    await tester.pumpAndSettle();
    expect(find.text('Compra #1048'), findsNothing);
    await tester.tap(find.text('Venta #00248'));
    await tester.pumpAndSettle();
    expect(find.text('Beige / L'), findsOneWidget);
    navigator(tester).pop();
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ChoiceChip, 'Compras'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Compra #1048'));
    await tester.pumpAndSettle();
    expect(find.text('Envío'), findsOneWidget);
    navigator(tester).pop();
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ChoiceChip, 'Inventario'));
    await tester.pumpAndSettle();
    final entrada = find.text('Entrada de stock').first;
    await tester.ensureVisible(entrada);
    await tester.pumpAndSettle();
    await tester.tap(entrada);
    await tester.pumpAndSettle();
    expect(find.text('Stock anterior'), findsOneWidget);
    expect(find.text('+12 unidades'), findsOneWidget);
    navigator(tester).pop();
    await tester.pumpAndSettle();
    tester.state<ScrollableState>(find.byType(Scrollable)).position.jumpTo(0);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ChoiceChip, 'LIVE'));
    await tester.pumpAndSettle();
    final domingo = find.text('Live Domingo');
    await tester.ensureVisible(domingo);
    await tester.pumpAndSettle();
    await tester.tap(domingo);
    await tester.pumpAndSettle();
    expect(find.text('Producto más vendido'), findsOneWidget);
    navigator(tester).pop();
    await tester.pumpAndSettle();
    tester.state<ScrollableState>(find.byType(Scrollable)).position.jumpTo(0);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ChoiceChip, 'Todo'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Hoy'));
    await tester.pumpAndSettle();
    expect(find.text('Venta #00248'), findsWidgets);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Personalizado'));
    await tester.pumpAndSettle();
    expect(find.text('Fecha inicial'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('un historial vacío tiene su propio mensaje', (tester) async {
    historyCatalog.replace(const []);
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AfyraApp());
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(of: find.byType(NavigationBar), matching: find.text('Más')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Historial'));
    await tester.pumpAndSettle();

    expect(find.text('Aún no hay actividad'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

NavigatorState navigator(WidgetTester tester) {
  return tester.state<NavigatorState>(find.byType(Navigator));
}
