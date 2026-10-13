import 'package:eco_reporte/app/eco_reporte_app.dart';
import 'package:eco_reporte/data/repositorio_simulado.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// Los cuatro estados de «Mis reportes» y el paso al detalle, en pantalla.
/// (Este archivo se llama widget_test.dart a propósito: así `flutter create .`
/// no lo reemplaza por la prueba del contador.)
void main() {
  Future<RepositorioSimulado> abrirApp(
    WidgetTester tester,
    Escenario escenario,
  ) async {
    final RepositorioSimulado repositorio = RepositorioSimulado(
      retardo: Duration.zero,
      ahora: DateTime(2026, 10, 13, 9),
    )..escenario = escenario;
    await tester.pumpWidget(
      EcoReporteApp(repositorio: repositorio, simulado: repositorio),
    );
    return repositorio;
  }

  testWidgets('Cargando: se ve el indicador de progreso', (WidgetTester tester) async {
    await abrirApp(tester, Escenario.cargando);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Lista vacía: invita a crear el primero', (WidgetTester tester) async {
    await abrirApp(tester, Escenario.vacio);
    await tester.pumpAndSettle();

    expect(find.text('Aún no tienes reportes'), findsOneWidget);
    expect(find.text('Crear el primero'), findsOneWidget);
  });

  testWidgets('No se pueden leer: mensaje llano y reintentar', (WidgetTester tester) async {
    final RepositorioSimulado repositorio = await abrirApp(tester, Escenario.falla);
    await tester.pumpAndSettle();

    expect(find.text('No pudimos leer tus reportes'), findsOneWidget);

    repositorio.escenario = Escenario.conDatos;
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();

    expect(find.text('No pudimos leer tus reportes'), findsNothing);
    expect(find.byType(Card), findsWidgets);
  });

  testWidgets('Lista con datos: el más reciente va de primero', (WidgetTester tester) async {
    await abrirApp(tester, Escenario.conDatos);
    await tester.pumpAndSettle();

    final Offset reciente =
        tester.getTopLeft(find.textContaining('Lote de la esquina'));
    final Offset anterior =
        tester.getTopLeft(find.textContaining('Separador de la avenida'));
    expect(reciente.dy, lessThan(anterior.dy));
  });

  testWidgets('HU-05: elegir un reporte abre su detalle', (WidgetTester tester) async {
    await abrirApp(tester, Escenario.conDatos);
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('Lote de la esquina'));
    await tester.pumpAndSettle();

    expect(find.text('Fecha y hora'), findsOneWidget);
    expect(find.text('Lugar'), findsOneWidget);
  });

  testWidgets('HU-05: en 360 dp el detalle no se desborda', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(720, 1600);
    tester.view.devicePixelRatio = 2; // 720 / 2 = 360 dp de ancho
    addTearDown(tester.view.reset);

    await abrirApp(tester, Escenario.conDatos);
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Orilla del caño'));
    await tester.pumpAndSettle();

    // Un desbordamiento lanzaría una excepción de renderizado.
    expect(tester.takeException(), isNull);
    expect(find.text('Ubicación aproximada'), findsOneWidget);
  });
}
