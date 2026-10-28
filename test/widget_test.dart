import 'dart:async';

import 'package:eco_reporte/app/eco_reporte_app.dart';
import 'package:eco_reporte/data/fotos/fuente_fotos.dart';
import 'package:eco_reporte/data/repositorio_simulado.dart';
import 'package:eco_reporte/data/ubicacion/fuente_ubicacion.dart';
import 'package:eco_reporte/ui/comun/logo.dart';
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
  late ServicioExportarFalso exportar;
  late PreferenciasFalsas preferencias;

  setUp(() {
    exportar = ServicioExportarFalso();
    preferencias = PreferenciasFalsas();
    compartir = ServicioCompartirFalso();
    fotos = FuenteFotosFalsa();
    almacen = AlmacenFotosFalso();
    ubicacion = FuenteUbicacionFalsa();
  });

  Future<RepositorioSimulado> abrirApp(
    WidgetTester tester,
    Escenario escenario, {
    bool telefono = true,
    String ruta = '/reportes',
  }) async {
    if (telefono) {
      // Pantalla de un teléfono común (411 × 914 dp) y no la de 800 × 600
      // que flutter_test usa por omisión: así el formulario se ve entero,
      // como en el teléfono, y sus campos existen para la prueba.
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.625;
      addTearDown(tester.view.reset);
    }
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
        exportar: exportar,
        preferencias: preferencias,
        rutaInicial: ruta,
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

    await abrirApp(tester, Escenario.conDatos, telefono: false);
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
    expect(find.text('Toca para tomar la foto'), findsOneWidget);
  });

  testWidgets('HU-01: cámara denegada explica para qué es y ofrece la galería',
      (WidgetTester tester) async {
    fotos.alTomar = const CamaraDenegada();
    await abrirApp(tester, Escenario.conDatos);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reportar'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Toca para tomar la foto'));
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

    await tester.ensureVisible(find.byType(TextFormField));
    await tester.pumpAndSettle();
    // El contador aparece solo cerca del límite (Sprint 6).
    expect(find.textContaining('Te quedan'), findsNothing);

    await tester.enterText(find.byType(TextFormField), 'x' * 100);
    await tester.pump();
    expect(find.text('Te quedan 20 caracteres'), findsOneWidget);

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

    await tester.tap(find.text('Toca para tomar la foto'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Frente a la cancha, junto al poste');
    await tester.pumpAndSettle();
    // Con la foto ya tomada el formulario crece: se baja hasta el botón.
    await tester.scrollUntilVisible(
      find.text('Guardar reporte'),
      200,
      scrollable: find
          .descendant(of: find.byType(ListView), matching: find.byType(Scrollable))
          .first,
    );
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

    // Desde el Sprint 5 el formulario es más largo (tipo de residuo) y el
    // ListView aún no construyó el botón: hay que desplazarse hasta él.
    await tester.scrollUntilVisible(
      find.text('Guardar reporte'),
      200,
      scrollable: find
          .descendant(of: find.byType(ListView), matching: find.byType(Scrollable))
          .first,
    );
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
    await tester.ensureVisible(find.byType(TextFormField));
    await tester.pumpAndSettle();
    expect(find.textContaining('Obligatoria: sin ubicación'), findsOneWidget);
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

  testWidgets('HU-04: con 200 reportes la lista se dibuja sin errores y solo construye lo visible',
      (WidgetTester tester) async {
    await abrirApp(tester, Escenario.doscientos);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    final int construidas = find.byType(Card).evaluate().length;
    expect(construidas, greaterThan(0));
    expect(construidas, lessThan(30), reason: 'ListView.builder no construye las 200');

    await tester.fling(find.byType(ListView), const Offset(0, -3000), 3000);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('HU-05: al volver del detalle, la lista está en la misma posición',
      (WidgetTester tester) async {
    await abrirApp(tester, Escenario.doscientos);
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -1500));
    await tester.pumpAndSettle();
    final ScrollableState lista = tester.state(find.byType(Scrollable).first);
    final double antes = lista.position.pixels;
    expect(antes, greaterThan(0));

    // Una fila que está en pantalla: la del centro.
    await tester.tapAt(const Offset(200, 300));
    await tester.pumpAndSettle();
    expect(find.text('Fecha y hora'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    final ScrollableState despues = tester.state(find.byType(Scrollable).first);
    expect(despues.position.pixels, antes);
  });

  testWidgets('TEC-05: el primer «Reportar» muestra el aviso de privacidad, el segundo no',
      (WidgetTester tester) async {
    preferencias.aceptado = false;
    await abrirApp(tester, Escenario.conDatos);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Reportar'));
    await tester.pumpAndSettle();
    expect(find.text('Antes de tu primer reporte'), findsOneWidget);
    expect(find.textContaining('Nunca en segundo plano'), findsOneWidget);

    // El botón está al final de una lista larga: hay que desplazarse hasta él.
    await tester.scrollUntilVisible(
      find.text('Entendido, crear mi reporte'),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Entendido, crear mi reporte'));
    await tester.pumpAndSettle();
    expect(find.text('Nuevo reporte'), findsOneWidget);
    expect(preferencias.aceptado, isTrue);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reportar'));
    await tester.pumpAndSettle();
    expect(find.text('Nuevo reporte'), findsOneWidget);
  });

  testWidgets('TEC-05: borrar pide confirmación y quita el reporte de la lista',
      (WidgetTester tester) async {
    await abrirApp(tester, Escenario.conDatos);
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Lote de la esquina'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Borrar'));
    await tester.pumpAndSettle();
    expect(find.text('¿Borrar este reporte?'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Borrar'));
    await tester.pumpAndSettle();

    expect(find.text('Mis reportes'), findsOneWidget);
    expect(find.textContaining('Lote de la esquina'), findsNothing);
    expect(find.text('Reporte borrado.'), findsOneWidget);
  });

  testWidgets('HU-06: el tipo elegido se guarda y se ve en la lista',
      (WidgetTester tester) async {
    await abrirApp(tester, Escenario.vacio);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reportar'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Toca para tomar la foto'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Lote de la calle 52');
    await tester.pumpAndSettle();
    final Finder formulario = find
        .descendant(of: find.byType(ListView), matching: find.byType(Scrollable))
        .first;
    await tester.scrollUntilVisible(find.text('Muebles y colchones'), 200,
        scrollable: formulario);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Muebles y colchones'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Guardar reporte'), 200,
        scrollable: formulario);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar reporte'));
    await tester.pumpAndSettle();

    expect(find.text('Mis reportes'), findsOneWidget);
    expect(find.text('Muebles y colchones'), findsOneWidget);
  });

  testWidgets('HU-06: el detalle dice «Sin clasificar» si no se eligió tipo',
      (WidgetTester tester) async {
    await abrirApp(tester, Escenario.conDatos);
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Esquina del colegio'));
    await tester.pumpAndSettle();

    expect(find.text('Tipo de residuo'), findsOneWidget);
    expect(find.text('Sin clasificar'), findsOneWidget);
  });

  testWidgets('HU-09: exportar pide el mes y comparte el listado',
      (WidgetTester tester) async {
    await abrirApp(tester, Escenario.conDatos);
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Exportar listado del mes'));
    await tester.pumpAndSettle();
    expect(find.text('¿De qué mes es el listado?'), findsOneWidget);
    expect(find.text('Octubre de 2026'), findsOneWidget);
    expect(find.text('5 reportes'), findsOneWidget);
    expect(find.text('Septiembre de 2026'), findsOneWidget);

    await tester.tap(find.text('Octubre de 2026'));
    await tester.pumpAndSettle();

    expect(exportar.veces, 1);
    expect(exportar.nombreArchivo, 'ecoreporte_2026-10.csv');
    expect(find.text('Listado de octubre de 2026 listo: 5 reportes.'), findsOneWidget);
  });

  testWidgets('HU-09: sin reportes no hay botón de exportar', (WidgetTester tester) async {
    await abrirApp(tester, Escenario.vacio);
    await tester.pumpAndSettle();

    expect(find.byTooltip('Exportar listado del mes'), findsNothing);
  });

  testWidgets('Sprint 6: la barra de abajo dice qué falta y «Guardar» siempre está a la vista',
      (WidgetTester tester) async {
    ubicacion.resultado = buenaSenal;
    await abrirApp(tester, Escenario.conDatos);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reportar'));
    await tester.pumpAndSettle();

    expect(find.text('Falta: la foto'), findsOneWidget);
    expect(find.text('Guardar reporte').hitTestable(), findsOneWidget,
        reason: 'el botón se ve sin desplazarse');

    await tester.tap(find.text('Toca para tomar la foto'));
    await tester.pumpAndSettle();

    expect(find.text('Listo. Se guarda aunque no tengas datos.'), findsOneWidget);
    expect(find.text('Guardar reporte').hitTestable(), findsOneWidget);
  });

  group('Sprint 6 · Pantalla de inicio', () {
    testWidgets('muestra el nombre, el eslogan y cuántos reportes hay',
        (WidgetTester tester) async {
      await abrirApp(tester, Escenario.conDatos, ruta: '/');
      await tester.pumpAndSettle();

      expect(find.text('EcoReporte'), findsOneWidget);
      expect(find.text('Tu barrio limpio empieza con una foto.'), findsOneWidget);
      expect(find.byType(LogoEcoReporte), findsOneWidget);
      expect(find.text('6 guardados en este teléfono'), findsOneWidget);
      expect(find.text('Reportar un punto').hitTestable(), findsOneWidget,
          reason: 'el botón principal se ve sin desplazarse');
    });

    testWidgets('«Reportar un punto» abre el formulario', (WidgetTester tester) async {
      await abrirApp(tester, Escenario.conDatos, ruta: '/');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Reportar un punto'));
      await tester.pumpAndSettle();

      expect(find.text('Nuevo reporte'), findsOneWidget);
    });

    testWidgets('«Mis reportes» abre la lista y «atrás» vuelve al inicio',
        (WidgetTester tester) async {
      await abrirApp(tester, Escenario.conDatos, ruta: '/');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Mis reportes'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Lote de la esquina'), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('EcoReporte'), findsOneWidget);
    });

    testWidgets('sin reportes, el listado del mes está apagado y lo dice',
        (WidgetTester tester) async {
      await abrirApp(tester, Escenario.vacio, ruta: '/');
      await tester.pumpAndSettle();

      expect(find.text('Aún no tienes reportes'), findsOneWidget);
      expect(find.text('Disponible cuando tengas reportes'), findsOneWidget);
      await tester.tap(find.text('Listado del mes'));
      await tester.pumpAndSettle();
      expect(find.text('¿De qué mes es el listado?'), findsNothing);
    });

    testWidgets('«Listado del mes» exporta desde el inicio', (WidgetTester tester) async {
      await abrirApp(tester, Escenario.conDatos, ruta: '/');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Listado del mes'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Octubre de 2026'));
      await tester.pumpAndSettle();

      expect(exportar.nombreArchivo, 'ecoreporte_2026-10.csv');
    });
  });
}
