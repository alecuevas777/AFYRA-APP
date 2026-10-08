import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:afyra/core/app.dart';
import 'package:afyra/core/utils/format.dart';
import 'package:afyra/data/mock/product_catalog.dart';
import 'package:afyra/data/mock/report_mock.dart';
import 'package:afyra/widgets/report_ranking.dart';

void main() {
  test('los totales del mes salen de las prendas', () {
    final month = reportFor('Este mes', products: productCatalog.products);
    final week = reportFor('Esta semana');
    final today = reportFor('Hoy');

    expect(month.estimatedProfit, month.revenue - month.cost);
    expect(month.revenue, month.lines.fold(0, (sum, line) => sum + line.revenue));
    expect(month.unitsSold, month.lines.fold(0, (sum, line) => sum + line.units));
    expect(month.bars.fold(0, (sum, bar) => sum + bar.amount), month.revenue);
    expect(month.averageTicket, (month.revenue / month.salesCount).round());
    expect(month.categories.fold(0, (sum, item) => sum + item.percent), 100);
    expect(month.lives.fold(0, (sum, live) => sum + live.income), lessThan(month.revenue));
    expect(week.lives.fold(0, (sum, live) => sum + live.income), lessThan(week.revenue));
    expect(today.salesCount, lessThan(week.salesCount));
    expect(week.salesCount, lessThan(month.salesCount));
    expect(month.salesCount, lessThan(reportFor('Últimos 3 meses').salesCount));
    expect(today.lives, isEmpty);
    expect(month.insights, isNotEmpty);
    expect(
      reportFor(
        'Personalizado',
        from: DateTime(2024, 1, 1),
        to: DateTime(2024, 1, 10),
      ).isEmpty,
      isTrue,
    );
  });

  testWidgets('los reportes cambian con el período y abren un cliente', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final month = reportFor('Este mes');
    final today = reportFor('Hoy');

    await tester.pumpWidget(const AfyraApp());
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(of: find.byType(NavigationBar), matching: find.text('Más')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reportes'));
    await tester.pumpAndSettle();

    expect(find.text('Conoce el rendimiento de tu negocio.'), findsOneWidget);
    expect(find.text(formatClp(month.revenue)), findsWidgets);
    expect(tester.takeException(), isNull);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Hoy'));
    await tester.pumpAndSettle();
    expect(find.text(formatClp(today.revenue)), findsWidgets);
    expect(find.text(formatClp(month.revenue)), findsNothing);
    expect(find.text('Sin LIVE finalizados en este período.'), findsOneWidget);

    final camila = find.text('Camila Rojas');
    await tester.ensureVisible(camila);
    await tester.pumpAndSettle();
    await tester.tap(camila);
    await tester.pumpAndSettle();
    expect(find.text('Casi siempre pide negro, talla M.'), findsOneWidget);
    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle();

    final product = find.descendant(
      of: find.byType(ProductRanking),
      matching: find.text('Polera Oversize Negra'),
    );
    await tester.ensureVisible(product);
    await tester.pumpAndSettle();
    await tester.tap(product);
    await tester.pumpAndSettle();
    expect(find.text('POL-OV-BLK'), findsOneWidget);
    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle();

    tester.state<ScrollableState>(find.byType(Scrollable)).position.jumpTo(0);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Personalizado'));
    await tester.pumpAndSettle();
    expect(find.text('Fecha inicial'), findsOneWidget);
    expect(find.text('Aplicar'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
