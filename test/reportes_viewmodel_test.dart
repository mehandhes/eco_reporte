import 'dart:async';

import 'package:eco_reporte/data/compartir/servicio_compartir.dart';
import 'package:eco_reporte/data/repositorio_simulado.dart';
import 'package:eco_reporte/domain/reporte.dart';
import 'package:eco_reporte/ui/reportes/reportes_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

import 'falsos.dart';

/// Los escenarios de HU-04, comprobados sobre el ViewModel.
void main() {
  late RepositorioSimulado repositorio;
  late ServicioCompartirFalso compartir;
  late AlmacenFotosFalso almacen;
  late ServicioExportarFalso exportar;
  late ReportesViewModel vm;

  setUp(() {
    exportar = ServicioExportarFalso();
    compartir = ServicioCompartirFalso();
    almacen = AlmacenFotosFalso();
    repositorio = RepositorioSimulado(
      retardo: Duration.zero,
      ahora: DateTime(2026, 10, 13, 9),
    );
    vm = ReportesViewModel(
      repositorio,
      compartir: compartir,
      almacen: almacen,
      exportar: exportar,
      reloj: () => DateTime(2026, 11, 9, 18),
    );
  });

  tearDown(() => vm.dispose());

  test('empieza en «cargando»', () {
    expect(vm.estado, EstadoUi.cargando);
  });

  test('Lista con datos: del más reciente al más antiguo', () async {
    await vm.cargar();

    expect(vm.estado, EstadoUi.listo);
    expect(vm.reportes, hasLength(6));
    for (int i = 1; i < vm.reportes.length; i++) {
      final Reporte anterior = vm.reportes[i - 1];
      final Reporte actual = vm.reportes[i];
      expect(anterior.fecha.isAfter(actual.fecha), isTrue);
    }
  });

  test('Lista vacía: estado «vacío», no «error»', () async {
    repositorio.escenario = Escenario.vacio;

    await vm.cargar();

    expect(vm.estado, EstadoUi.vacio);
    expect(vm.reportes, isEmpty);
  });

  test('No se pueden leer: estado «error», y reintentar se recupera', () async {
    repositorio.escenario = Escenario.falla;
    await vm.cargar();
    expect(vm.estado, EstadoUi.error);

    repositorio.escenario = Escenario.conDatos;
    await vm.cargar();
    expect(vm.estado, EstadoUi.listo);
  });

  test('mientras no llegan los datos, sigue en «cargando»', () async {
    repositorio.escenario = Escenario.cargando;

    unawaited(vm.cargar());
    await Future<void>.delayed(Duration.zero);

    expect(vm.estado, EstadoUi.cargando);
  });

  test('HU-05: buscar devuelve el reporte por su id, o nulo', () async {
    await vm.cargar();

    expect(vm.buscar(4)?.ubicacionAproximada, isTrue);
    expect(vm.buscar(5)?.tieneUbicacion, isFalse);
    expect(vm.buscar(99), isNull);
  });

  group('HU-10 · Compartir', () {
    test('lleva la foto y el mensaje, y deja el reporte marcado', () async {
      await vm.cargar();

      final ResultadoCompartir resultado = await vm.compartir(1);

      expect(resultado, ResultadoCompartir.compartido);
      expect(compartir.ultimoTexto, contains('Lote de la esquina'));
      expect(compartir.ultimoTexto, contains('google.com/maps'));
      expect(vm.buscar(1)!.fueCompartido, isTrue);
      expect(vm.buscar(1)!.compartidoEn, DateTime(2026, 11, 9, 18));
    });

    test('si cierra el menú sin elegir, no se marca', () async {
      await vm.cargar();
      compartir.resultado = ResultadoCompartir.cancelado;

      await vm.compartir(1);

      expect(vm.buscar(1)!.fueCompartido, isFalse);
    });

    test('la marca sobrevive a volver a cargar la lista', () async {
      await vm.cargar();
      await vm.compartir(2);

      await vm.cargar();

      expect(vm.buscar(2)!.fueCompartido, isTrue);
    });
  });

  group('HU-09 · Exportar el listado del mes', () {
    test('los meses con reportes, del más reciente al más antiguo', () async {
      await vm.cargar();

      // Los ejemplos van del 13 oct 2026 hacia atrás, hasta el 23 sep.
      expect(vm.mesesExportables, <DateTime>[DateTime(2026, 10), DateTime(2026, 9)]);
      expect(vm.cuantosEn(DateTime(2026, 10)), 5);
      expect(vm.cuantosEn(DateTime(2026, 9)), 1);
    });

    test('exporta solo el mes elegido, con su nombre de archivo', () async {
      await vm.cargar();

      final ResultadoCompartir r = await vm.exportarMes(DateTime(2026, 9));

      expect(r, ResultadoCompartir.compartido);
      expect(exportar.veces, 1);
      expect(exportar.nombreArchivo, 'ecoreporte_2026-09.csv');
      expect(exportar.texto, contains('septiembre de 2026 · 1 reporte '));
      final List<String> lineas = exportar.contenido!.trim().split('\r\n');
      expect(lineas, hasLength(2), reason: 'encabezado + 1 reporte');
      expect(lineas[1], contains('Entrada del callejón'));
    });

    test('un mes sin reportes no produce un archivo vacío', () async {
      await vm.cargar();

      final ResultadoCompartir r = await vm.exportarMes(DateTime(2026, 1));

      expect(r, ResultadoCompartir.cancelado);
      expect(exportar.veces, 0);
    });

    test('si el teléfono no puede compartir, se informa como fallido', () async {
      await vm.cargar();
      exportar.resultado = ResultadoCompartir.fallido;

      expect(await vm.exportarMes(DateTime(2026, 10)), ResultadoCompartir.fallido);
      expect(vm.exportando, isFalse);
    });
  });

  group('TEC-05 · Borrar un reporte', () {
    test('desaparece de la lista y no vuelve al recargar', () async {
      await vm.cargar();

      expect(await vm.eliminar(3), isTrue);
      expect(vm.buscar(3), isNull);
      expect(vm.reportes, hasLength(5));

      await vm.cargar();
      expect(vm.buscar(3), isNull);
    });

    test('se borra también la foto del teléfono', () async {
      final RepositorioFalso conFoto = RepositorioFalso();
      final Reporte r = await conFoto.guardar(
        BorradorReporte(
          fecha: DateTime(2026, 11, 2),
          referencia: 'a',
          rutaFoto: '/app/fotos/1.jpg',
        ),
      );
      final ReportesViewModel otro = ReportesViewModel(
        conFoto,
        compartir: compartir,
        almacen: almacen,
        exportar: exportar,
      );
      addTearDown(otro.dispose);
      await otro.cargar();

      await otro.eliminar(r.id);

      expect(almacen.borradas, <String>['/app/fotos/1.jpg']);
      expect(otro.estado, EstadoUi.vacio);
    });
  });
}
