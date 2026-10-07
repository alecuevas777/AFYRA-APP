import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:afyra/core/app.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/data/mock/dashboard_mock.dart';
import 'package:afyra/data/mock/live_catalog.dart';

void main() {
  test('formatea pesos chilenos', () {
    expect(formatClp(245000), '\$245.000');
    expect(formatClp(18990), '\$18.990');
    expect(formatClp(0), '\$0');
  });

  test('elige el saludo según la hora', () {
    expect(greetingFor(DateTime(2026, 10, 5, 9)), 'Buenos días');
    expect(greetingFor(DateTime(2026, 10, 5, 15)), 'Buenas tardes');
    expect(greetingFor(DateTime(2026, 10, 5, 21)), 'Buenas noches');
  });

  testWidgets('el dashboard muestra el resumen del día', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AfyraApp());
    await tester.pumpAndSettle();

    expect(find.text('Alexis'), findsOneWidget);
    expect(find.text(formatClp(dashboardMock.income)), findsOneWidget);
    expect(find.text('Polera Oversize Negra'), findsOneWidget);
    expect(find.text('Iniciar LIVE'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('la navegación abre el espacio de productos', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AfyraApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Productos'));
    await tester.pumpAndSettle();

    expect(find.text('Buscar por nombre o SKU'), findsOneWidget);
    expect(find.text('Polera Oversize Negra'), findsOneWidget);
  });

  testWidgets('el botón LIVE abre el panel activo', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    liveCatalog.reset();

    await tester.pumpWidget(const AfyraApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Iniciar LIVE'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Nuevo Drop'), findsOneWidget);
  });
}
