import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:afyra/core/app.dart';
import 'package:afyra/data/mock/settings_store.dart';

void main() {
  tearDown(settingsStore.reset);

  test('el umbral de stock se mantiene entre 1 y 20', () {
    settingsStore.setLowStockThreshold(0);
    expect(settingsStore.lowStockThreshold, 1);
    settingsStore.setLowStockThreshold(40);
    expect(settingsStore.lowStockThreshold, 20);
    settingsStore.saveBusiness(
      name: 'Ayra Studio',
      instagram: '@ayra.cl',
      whatsapp: '+56 9 1111 0000',
      phone: '+56 9 1111 0000',
      address: 'Concepción, Chile',
    );
    expect(settingsStore.businessName, 'Ayra Studio');
  });

  testWidgets('la configuración guarda el negocio y pide confirmación al salir', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AfyraApp());
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(of: find.byType(NavigationBar), matching: find.text('Más')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ajustes llegan en una etapa posterior.'), findsNothing);
    final settings = find.text('Configuración');
    await tester.scrollUntilVisible(settings, 200);
    await tester.tap(settings);
    await tester.pumpAndSettle();

    expect(find.text('Personaliza la aplicación y tu negocio.'), findsOneWidget);
    expect(find.text('Ayra · @ayra.cl'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Información del negocio'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('business-name')), 'Ayra Studio');
    await tester.tap(find.text('Guardar cambios'));
    await tester.pump();
    expect(find.text('Información actualizada'), findsOneWidget);

    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle();
    expect(find.text('Ayra Studio · @ayra.cl'), findsOneWidget);

    await tester.tap(find.text('Moneda, costos y confirmaciones'));
    await tester.pumpAndSettle();
    expect(find.text('Peso chileno (CLP)'), findsOneWidget);
    await tester.tap(find.byType(Switch).first);
    await tester.pump();
    expect(settingsStore.showCosts, isFalse);

    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mi perfil'));
    await tester.pumpAndSettle();
    expect(find.text('alexis@example.com'), findsOneWidget);
    expect(find.text('Administrador'), findsOneWidget);
    await tester.tap(find.text('Cerrar sesión'));
    await tester.pumpAndSettle();
    expect(find.text('¿Cerrar sesión?'), findsOneWidget);
    expect(find.text('Esta acción cerrará tu sesión actual.'), findsOneWidget);
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(find.text('Editar perfil'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
