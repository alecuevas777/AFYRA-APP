import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:afyra/core/app.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/data/mock/live_catalog.dart';
import 'package:afyra/data/mock/product_catalog.dart';

void main() {
  setUp(liveCatalog.reset);

  test('el LIVE activo parte con el resumen de la transmisión', () {
    final session = liveCatalog.active!;
    expect(session.name, 'Nuevo Drop');
    expect(session.salesCount, 18);
    expect(session.unitsSold, 24);
    expect(session.income, 245000);
    expect(session.estimatedCost, 158000);
    expect(session.profit, 87000);
    expect(session.averageTicket, 13611);
    expect(session.featuredName, 'Polera Oversize Negra');
    expect(session.featuredUnits, 5);
    expect(session.stockOf('oversize', 'Negro', 'M'), 4);
    expect(formatDuration(const Duration(hours: 1, minutes: 40)), '01:40:00');
  });

  test('una venta del LIVE baja el stock de la sesión', () {
    final before = productCatalog.find('oversize')!.totalStock;
    final record = liveCatalog.sell(
      product: productCatalog.find('oversize')!,
      color: 'Negro',
      size: 'M',
      quantity: 1,
      payment: liveCatalog.active!.openingSales.first.payment,
    );

    expect(record, isNotNull);
    expect(record!.total, 24990);
    expect(liveCatalog.active!.stockOf('oversize', 'Negro', 'M'), 3);
    expect(liveCatalog.active!.salesCount, 19);
    expect(productCatalog.find('oversize')!.totalStock, before);
  });

  testWidgets('el panel permite buscar, vender y cerrar el LIVE', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AfyraApp());
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('LIVE'),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Nuevo Drop'), findsOneWidget);
    expect(find.text(formatClp(245000)), findsOneWidget);
    expect(find.text('Live Domingo'), findsNothing);

    await tester.tap(find.text('Resumen'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Ticket promedio'), findsOneWidget);
    expect(find.text(formatClp(13611)), findsOneWidget);
    expect(find.text('5 ventas'), findsOneWidget);
    await tester.tapAt(const Offset(20, 20));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    await tester.enterText(find.widgetWithText(TextField, 'Buscar producto'), 'polera');
    await tester.pump();
    expect(find.text('Hoodie Essential'), findsNothing);
    expect(find.text('Polera Oversize Negra'), findsOneWidget);
    expect(find.text('Polera Básica Blanca'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'Buscar producto'), '');
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('live-sell-oversize')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Sin cliente'), findsOneWidget);
    expect(find.text('Negro'), findsWidgets);
    expect(find.text('Stock 4'), findsWidgets);

    await tester.tap(find.text('Blanco').hitTestable().first);
    await tester.pump();
    expect(find.textContaining('Agotado'), findsWidgets);

    await tester.tap(find.text('Negro').hitTestable().first);
    await tester.pump();
    await tester.tap(find.text('Elegir'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    final sheetList = find.byType(ListView).hitTestable();
    for (var i = 0; i < 6 && find.text('Camila Rojas').hitTestable().evaluate().isEmpty; i++) {
      await tester.drag(sheetList.last, const Offset(0, -280));
      await tester.pump();
    }
    await tester.tap(find.text('Camila Rojas').hitTestable());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Camila Rojas'), findsOneWidget);

    await tester.tap(find.byKey(const Key('confirm-live-sale')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Venta registrada'), findsOneWidget);
    expect(find.text('Seguir vendiendo'), findsOneWidget);

    await tester.tap(find.text('Seguir vendiendo'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Stock bajo · 3'), findsOneWidget);

    await tester.tap(find.text('Últimas ventas'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Camila Rojas'), findsWidgets);
    await tester.tapAt(const Offset(20, 20));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(find.text('Finalizar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('¿Finalizar LIVE?'), findsOneWidget);
    await tester.tap(find.text('Cancelar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Nuevo Drop'), findsOneWidget);

    await tester.tap(find.text('Finalizar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.text('Finalizar LIVE'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('LIVE finalizado'), findsOneWidget);
    expect(find.text('Producto más vendido'), findsOneWidget);

    await tester.tap(find.text('Ver ventas'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Camila Rojas'), findsWidgets);
    await _pop(tester);

    await _pop(tester);
    expect(find.text('Live Domingo'), findsOneWidget);
    expect(find.textContaining(formatClp(428000)), findsOneWidget);

    await tester.tap(find.text('Live Domingo').hitTestable());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text(formatClp(146000)), findsOneWidget);
    await tester.tap(find.text('Nuevo LIVE'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('48'), findsOneWidget);
    expect(find.text('126'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('live-name')), '');
    await tester.tap(find.byKey(const Key('start-live')));
    await tester.pump();
    expect(find.text('Escribe un nombre para el LIVE.'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('live-name')), 'Live prueba');
    await tester.tap(find.byKey(const Key('start-live')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Live prueba'), findsWidgets);
    expect(find.text('0'), findsWidgets);
  });
}

Future<void> _pop(WidgetTester tester) async {
  tester.state<NavigatorState>(find.byType(Navigator)).pop();
  await tester.pump();
  for (var i = 0; i < 8; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}
