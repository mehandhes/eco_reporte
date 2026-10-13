import 'dart:async';

import '../domain/reporte.dart';
import 'reporte_repository.dart';

/// Los cuatro casos que toda lista tiene que saber dibujar.
enum Escenario { conDatos, vacio, falla, cargando }

/// Repositorio con datos de ejemplo para la prueba técnica del Sprint 1
/// (INV-04). Permite elegir el escenario desde la app, solo en desarrollo,
/// para ver en el teléfono los cuatro estados de «Mis reportes».
class RepositorioSimulado implements ReporteRepository {
  RepositorioSimulado({
    this.retardo = const Duration(milliseconds: 1500),
    DateTime? ahora,
  }) : _ahora = ahora ?? DateTime.now();

  /// Espera artificial para que el estado «cargando» se alcance a ver.
  final Duration retardo;
  final DateTime _ahora;

  Escenario escenario = Escenario.conDatos;

  @override
  Future<List<Reporte>> obtenerTodos() async {
    if (escenario == Escenario.cargando) {
      // Nunca termina: deja la pantalla en «cargando» para revisarla.
      return Completer<List<Reporte>>().future;
    }
    await Future<void>.delayed(retardo);
    if (escenario == Escenario.falla) {
      throw const ErrorDeLectura('falla simulada');
    }
    if (escenario == Escenario.vacio) {
      return const <Reporte>[];
    }
    final List<Reporte> lista = _ejemplos();
    lista.sort((Reporte a, Reporte b) => b.fecha.compareTo(a.fecha));
    return lista;
  }

  /// Seis reportes verosímiles del barrio Primero de Mayo, en desorden a
  /// propósito: el repositorio los entrega ordenados (HU-04).
  List<Reporte> _ejemplos() {
    return <Reporte>[
      Reporte(
        id: 3,
        fecha: _ahora.subtract(const Duration(days: 4, hours: 2)),
        referencia: 'Detrás del salón comunal, junto a la cancha de microfútbol',
        latitud: 7.06612,
        longitud: -73.85231,
        precisionMetros: 12,
      ),
      Reporte(
        id: 1,
        fecha: _ahora.subtract(const Duration(hours: 3)),
        referencia: 'Lote de la esquina de la calle 52, frente a la tienda',
        latitud: 7.06531,
        longitud: -73.85472,
        precisionMetros: 8,
      ),
      Reporte(
        id: 5,
        fecha: _ahora.subtract(const Duration(days: 12, hours: 6)),
        referencia: 'Esquina del colegio, al lado del poste de la luz',
        // Sin coordenadas: la vecina negó el permiso de ubicación (HU-02).
      ),
      Reporte(
        id: 2,
        fecha: _ahora.subtract(const Duration(days: 1, hours: 5)),
        referencia: 'Separador de la avenida, junto al paradero de buses',
        latitud: 7.06398,
        longitud: -73.85610,
        precisionMetros: 15,
      ),
      Reporte(
        id: 6,
        fecha: _ahora.subtract(const Duration(days: 20)),
        referencia: 'Entrada del callejón que sale a la iglesia',
        latitud: 7.06702,
        longitud: -73.85388,
        precisionMetros: 20,
      ),
      Reporte(
        id: 4,
        fecha: _ahora.subtract(const Duration(days: 7, hours: 1)),
        referencia: 'Orilla del caño, bajando por la carrera 36',
        latitud: 7.06244,
        longitud: -73.85155,
        // Peor que 50 m: el detalle muestra «Ubicación aproximada».
        precisionMetros: 64,
      ),
    ];
  }
}
