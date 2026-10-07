import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:afyra/core/app.dart';
import 'package:afyra/data/mock/customer_catalog.dart';
import 'package:afyra/models/customer.dart';

void main() {
  setUp(customerCatalog.reset);

  test('separa frecuentes, recientes y clientes sin compras', () {
    final now = DateTime.now();
    final camila = customerCatalog.find('camila')!;
    final antonia = customerCatalog.find('antonia')!;
    final daniela = customerCatalog.find('daniela')!;

    expect(camila.frequent, isTrue);
    expect(camila.purchaseCount, 3);
    expect(antonia.purchaseCount, 0);
    expect(daniela.isNewOn(now), isTrue);
    expect(customerMatchesFilter(antonia, 'Sin compras', now), isTrue);
    expect(customerMatchesFilter(camila, 'Sin compras', now), isFalse);
    expect(customerMatchesQuery(customerCatalog.find('sofia')!, '2295'), isTrue);
  });

  testWidgets('la lista busca, filtra y muestra un cliente sin compras', (tester) async {
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
    await tester.tap(find.text('Clientes'));
    await tester.pumpAndSettle();

    expect(find.text('Camila Rojas'), findsOneWidget);
    expect(find.text('Gestiona tus clientes y conoce mejor sus compras.'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'Buscar cliente...'), '2201');
    await tester.pumpAndSettle();
    expect(find.text('Camila Rojas'), findsOneWidget);
    expect(find.text('Javiera Soto'), findsNothing);

    await tester.enterText(find.widgetWithText(TextField, 'Buscar cliente...'), 'zzzz');
    await tester.pumpAndSettle();
    expect(find.text('No encontramos clientes'), findsOneWidget);
    expect(find.text('Prueba con otro nombre o teléfono.'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'Buscar cliente...'), '');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sin compras'));
    await tester.pumpAndSettle();
    expect(find.text('Antonia Reyes'), findsOneWidget);
    expect(find.text('Camila Rojas'), findsNothing);

    await tester.tap(find.text('Antonia Reyes'));
    await tester.pumpAndSettle();
    expect(find.text('Aún no hay compras'), findsOneWidget);
    expect(find.text('Este cliente todavía no registra compras.'), findsOneWidget);
  });

  testWidgets('se puede crear un cliente y ver el historial de Camila', (tester) async {
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
    await tester.tap(find.text('Clientes'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Camila Rojas'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Venta #00248'), findsOneWidget);
    await tester.tap(find.textContaining('Venta #00248'));
    await tester.pumpAndSettle();
    expect(find.text('Beige / L'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('add-customer')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-customer')));
    await tester.pumpAndSettle();
    expect(find.text('Escribe el nombre.'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('customer-name')), 'Isidora León');
    await tester.enterText(find.byKey(const Key('customer-phone')), '+56 9 5555 0101');
    await tester.tap(find.byKey(const Key('save-customer')));
    await tester.pumpAndSettle();
    expect(find.text('Cliente guardado'), findsOneWidget);
    await tester.tap(find.text('Listo'));
    await tester.pumpAndSettle();
    expect(find.text('Isidora León'), findsOneWidget);

    await tester.tap(find.text('Isidora León'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Editar'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('customer-name')), 'Isidora León Díaz');
    await tester.tap(find.byKey(const Key('save-customer')));
    await tester.pumpAndSettle();
    expect(find.text('Cliente actualizado'), findsOneWidget);
  });

  testWidgets('una venta puede crear y dejar seleccionado al cliente', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AfyraApp());
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(of: find.byType(NavigationBar), matching: find.text('Ventas')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Nueva venta'));
    await tester.pumpAndSettle();

    final select = find.text('Seleccionar');
    for (var i = 0; i < 8 && select.evaluate().isEmpty; i++) {
      await tester.drag(find.byType(ListView).hitTestable(), const Offset(0, -450));
      await tester.pumpAndSettle();
    }
    await tester.ensureVisible(select);
    await tester.tap(select);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('create-customer')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('customer-name')), 'Rosa Aguilar');
    await tester.enterText(find.byKey(const Key('customer-phone')), '+56 9 5555 2020');
    await tester.tap(find.byKey(const Key('save-quick-customer')));
    await tester.pumpAndSettle();

    expect(find.text('Rosa Aguilar'), findsWidgets);
    expect(customerCatalog.customers.first.name, 'Rosa Aguilar');
  });
}
