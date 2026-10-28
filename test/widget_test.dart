import 'dart:async';

import 'package:eco_reporte/app/eco_reporte_app.dart';
import 'package:eco_reporte/data/fotos/fuente_fotos.dart';
import 'package:eco_reporte/data/repositorio_simulado.dart';
import 'package:eco_reporte/data/ubicacion/fuente_ubicacion.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'falsos.dart';

/// Los cuatro estados de «Mis reportes» y el paso al detalle, en pantalla.
/// (Este archivo se llama widget_test.dart a propósito: así `flutter create .`
/// no lo reemplaza por la prueba del contador.)
void main() {
  late FuenteFotosFalsa fotos;
  late AlmacenFotosFalso almacen;
  late FuenteUbicacionFalsa ubicacion;
  late ServicioCompartirFalso compartir;

  setUp(() {
    compartir = ServicioCompartirFalso();
    fotos = FuenteFotosFalsa();
    almacen = AlmacenFotosFalso();
    ubicacion = FuenteUbicacionFalsa();
  });

  Future<RepositorioSimulado> abrirApp(
    WidgetTester tester,
    Escenario escenario,
  ) async {
    final RepositorioSimulado repositorio = RepositorioSimulado(
      retardo: Duration.zero,
      ahora: DateTime(2026, 10, 13, 9),
    )..escenario = escenario;
    await tester.pumpWidget(
      EcoReporteApp(
        repositorio: repositorio,
        simulado: repositorio,
        fotos: fotos,
        almacen: almacen,
        ubicacion: ubicacion,
        compartir: compartir,
      ),
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

  testWidgets('HU-01: «Reportar» abre el formulario con la foto', (WidgetTester tester) async {
    await abrirApp(tester, Escenario.conDatos);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Reportar'));
    await tester.pumpAndSettle();

    expect(find.text('Nuevo reporte'), findsOneWidget);
    expect(find.text('Toca para tomar la foto *'), findsOneWidget);
  });

  testWidgets('HU-01: cámara denegada explica para qué es y ofrece la galería',
      (WidgetTester tester) async {
    fotos.alTomar = const CamaraDenegada();
    await abrirApp(tester, Escenario.conDatos);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reportar'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Toca para tomar la foto *'));
    await tester.pumpAndSettle();

    expect(find.textContaining('estado real del lugar'), findsOneWidget);
    expect(find.text('Elegir de la galería'), findsOneWidget);
  });

  testWidgets('HU-12: la referencia no pasa de 120 caracteres y dice cuánto queda',
      (WidgetTester tester) async {
    await abrirApp(tester, Escenario.conDatos);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reportar'));
    await tester.pumpAndSettle();

    expect(find.text('Te quedan 120 caracteres'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'x' * 130);
    await tester.pump();

    final EditableText campo = tester.widget(find.byType(EditableText));
    expect(campo.controller.text.length, 120);
    expect(find.text('Llegaste al límite de 120 caracteres'), findsOneWidget);
  });

  testWidgets('HU-03: guardar confirma qué sigue y el reporte queda de primero',
      (WidgetTester tester) async {
    await abrirApp(tester, Escenario.conDatos);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reportar'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Toca para tomar la foto *'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Frente a la cancha, junto al poste');
    await tester.ensureVisible(find.text('Guardar reporte'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar reporte'));
    await tester.pumpAndSettle();

    expect(find.text('Mis reportes'), findsOneWidget);
    expect(find.textContaining('compartirlo con tu JAC'), findsOneWidget);
    final double nuevo = tester.getTopLeft(find.text('Frente a la cancha, junto al poste')).dy;
    final double anterior = tester.getTopLeft(find.textContaining('Lote de la esquina')).dy;
    expect(nuevo, lessThan(anterior));
  });

  testWidgets('HU-03: sin foto no se guarda y se dice qué falta', (WidgetTester tester) async {
    await abrirApp(tester, Escenario.conDatos);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reportar'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Guardar reporte'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar reporte'));
    await tester.pumpAndSettle();

    expect(find.text('Nuevo reporte'), findsOneWidget);
    expect(find.textContaining('Falta la foto'), findsOneWidget);
    expect(find.textContaining('Escribe una referencia'), findsOneWidget);
    expect(almacen.guardadas, isEmpty);
  });

  testWidgets('HU-02: al abrir el formulario se busca la ubicación sola',
      (WidgetTester tester) async {
    ubicacion.enCurso = Completer<ResultadoUbicacion>();
    await abrirApp(tester, Escenario.conDatos);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reportar'));
    // No pumpAndSettle: el indicador de progreso gira sin parar.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Buscando tu ubicación…'), findsOneWidget);
    expect(ubicacion.veces, 1);

    ubicacion.enCurso!.complete(buenaSenal);
    await tester.pumpAndSettle();
    expect(find.text('Ubicación lista'), findsOneWidget);
    expect(find.textContaining('7.06531, -73.85472'), findsOneWidget);
  });

  testWidgets('HU-02: sin permiso, dice para qué es y deja reportar con referencia',
      (WidgetTester tester) async {
    await abrirApp(tester, Escenario.conDatos);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reportar'));
    await tester.pumpAndSettle();

    expect(find.text('Sin permiso de ubicación'), findsOneWidget);
    expect(find.textContaining('una sola vez, mientras llenas este reporte'), findsOneWidget);
    expect(find.text('Referencia del lugar *'), findsOneWidget);
  });

  testWidgets('HU-02: precisión peor que 50 m muestra «Ubicación aproximada»',
      (WidgetTester tester) async {
    ubicacion.resultado = const UbicacionObtenida(
      latitud: 7.06244,
      longitud: -73.85155,
      precisionMetros: 64,
    );
    await abrirApp(tester, Escenario.conDatos);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reportar'));
    await tester.pumpAndSettle();

    expect(find.text('Ubicación aproximada'), findsOneWidget);
    expect(find.text('Pedir de nuevo'), findsOneWidget);
  });

  testWidgets('HU-10: compartir desde el detalle deja la marca en la lista',
      (WidgetTester tester) async {
    await abrirApp(tester, Escenario.conDatos);
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Lote de la esquina'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Compartir por WhatsApp'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Compartir por WhatsApp'));
    await tester.pumpAndSettle();

    expect(compartir.veces, 1);
    expect(compartir.ultimoTexto, contains('google.com/maps'));
    expect(find.text('Compartido'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.textContaining('Compartido'), findsOneWidget);
  });
}
