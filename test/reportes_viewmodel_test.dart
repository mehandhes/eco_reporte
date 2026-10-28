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
  late ReportesViewModel vm;

  setUp(() {
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
      final ReportesViewModel otro =
          ReportesViewModel(conFoto, compartir: compartir, almacen: almacen);
      addTearDown(otro.dispose);
      await otro.cargar();

      await otro.eliminar(r.id);

      expect(almacen.borradas, <String>['/app/fotos/1.jpg']);
      expect(otro.estado, EstadoUi.vacio);
    });
  });
}
