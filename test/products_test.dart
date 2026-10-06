import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:afyra/core/app.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/data/mock/product_catalog.dart';
import 'package:afyra/models/product.dart';

void main() {
  setUp(productCatalog.reset);

  Future<void> openProducts(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AfyraApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Productos'));
    await tester.pumpAndSettle();
  }

  test('suma el stock de las variantes y distingue el nivel', () {
    final oversize = productCatalog.find('oversize')!;
    final hoodie = productCatalog.find('hoodie')!;
    final jeans = productCatalog.find('jeans')!;

    expect(oversize.totalStock, 8);
    expect(oversize.margin, 12990);
    expect(oversize.level, StockLevel.ok);
    expect(hoodie.level, StockLevel.low);
    expect(jeans.level, StockLevel.out);
    expect(oversize.variantsByColor.keys, ['Negro', 'Blanco']);
  });

  testWidgets('la búsqueda por SKU deja solo esa prenda', (tester) async {
    await openProducts(tester);
    await tester.enterText(find.byType(TextField), 'JNS-WL');
    await tester.pumpAndSettle();

    expect(find.text('Jeans Wide Leg'), findsOneWidget);
    expect(find.text('Hoodie Essential'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('el filtro de agotados muestra el jean', (tester) async {
    await openProducts(tester);
    await tester.tap(find.text('Agotados'));
    await tester.pumpAndSettle();

    expect(find.text('Jeans Wide Leg'), findsOneWidget);
    expect(find.text('Crop Top Basic'), findsNothing);
  });

  testWidgets('el detalle muestra margen y tallas', (tester) async {
    await openProducts(tester);
    await tester.tap(find.text('Polera Oversize Negra'));
    await tester.pumpAndSettle();

    expect(find.text('POL-OV-BLK'), findsOneWidget);
    expect(find.text(formatClp(12990)), findsOneWidget);
    expect(find.text('Negro'), findsWidgets);
    expect(find.text('Blanco'), findsWidgets);
    expect(find.text('M'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('crear y editar muestran el mismo formulario', (tester) async {
    await openProducts(tester);
    await tester.tap(find.byTooltip('Agregar producto'));
    await tester.pumpAndSettle();

    expect(find.text('Nuevo producto'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('product-name')), 'Blazer Arena');
    await tester.drag(find.byType(ListView), const Offset(0, -320));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('product-price')).hitTestable(),
      '45990',
    );
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('Blazer Arena'), findsOneWidget);
    expect(productCatalog.find('oversize'), isNotNull);

    await tester.tap(find.text('Blazer Arena'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Editar'));
    await tester.pumpAndSettle();

    expect(find.text('Editar producto'), findsOneWidget);
    expect(find.text('Blazer Arena'), findsOneWidget);
  });

  testWidgets('inventario muestra el resumen y un movimiento', (tester) async {
    await openProducts(tester);
    await tester.tap(find.text('Inventario'));
    await tester.pumpAndSettle();

    expect(find.text('Stock total'), findsOneWidget);
    expect(find.text('Entrada'), findsWidgets);
    expect(find.text('Ajuste'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
