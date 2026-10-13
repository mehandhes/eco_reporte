import 'dart:async';

import 'package:eco_reporte/data/repositorio_simulado.dart';
import 'package:eco_reporte/domain/reporte.dart';
import 'package:eco_reporte/ui/reportes/reportes_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

/// Los escenarios de HU-04, comprobados sobre el ViewModel.
void main() {
  late RepositorioSimulado repositorio;
  late ReportesViewModel vm;

  setUp(() {
    repositorio = RepositorioSimulado(
      retardo: Duration.zero,
      ahora: DateTime(2026, 10, 13, 9),
    );
    vm = ReportesViewModel(repositorio);
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
}
