import 'dart:async';

import '../domain/reporte.dart';
import 'reporte_repository.dart';

/// Los cuatro casos que toda lista tiene que saber dibujar, más uno para
/// medir el rendimiento (RC-03).
enum Escenario { conDatos, vacio, falla, cargando, doscientos }

/// Repositorio con datos de ejemplo. Nació en la prueba técnica del Sprint 1
/// (INV-04) y sigue vivo por dos razones:
///
/// * las pruebas de widgets lo usan para ver los cuatro estados sin base;
/// * en desarrollo se puede arrancar la app con él para revisar esos
///   estados en el teléfono: `flutter run --dart-define=DATOS=simulados`.
class RepositorioSimulado implements ReporteRepository {
  RepositorioSimulado({
    this.retardo = const Duration(milliseconds: 1500),
    DateTime? ahora,
  }) : _ahora = ahora ?? DateTime.now();

  /// Espera artificial para que el estado «cargando» se alcance a ver.
  final Duration retardo;
  final DateTime _ahora;

  Escenario escenario = Escenario.conDatos;

  /// Lo que se guardó durante la sesión, encima de los ejemplos.
  final List<Reporte> _guardados = <Reporte>[];
  int _siguienteId = 100;

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
      return List<Reporte>.of(_guardados);
    }
    final List<Reporte> lista = _todos()
        .map((Reporte r) =>
            _compartidos.containsKey(r.id) ? r.compartido(_compartidos[r.id]!) : r)
        .toList();
    lista.sort((Reporte a, Reporte b) => b.fecha.compareTo(a.fecha));
    return lista;
  }

  @override
  Future<Reporte> guardar(BorradorReporte borrador) async {
    await Future<void>.delayed(retardo);
    final Reporte reporte = borrador.conId(_siguienteId++);
    _guardados.insert(0, reporte);
    return reporte;
  }

  /// Las marcas de «compartido» de la sesión, por id.
  final Map<int, DateTime> _compartidos = <int, DateTime>{};

  @override
  Future<Reporte> marcarCompartido(int id, DateTime cuando) async {
    _compartidos[id] = cuando;
    return _todos().firstWhere((Reporte r) => r.id == id).compartido(cuando);
  }

  /// Los ids borrados durante la sesión.
  final Set<int> _borrados = <int>{};

  @override
  Future<void> eliminar(int id) async {
    _borrados.add(id);
    _guardados.removeWhere((Reporte r) => r.id == id);
  }

  List<Reporte> _todos() => <Reporte>[
        ..._guardados,
        ...(escenario == Escenario.doscientos ? _doscientos() : _ejemplos()),
      ].where((Reporte r) => !_borrados.contains(r.id)).toList();

  /// RC-03 · 200 reportes para medir «Mis reportes» en un Android de gama
  /// de entrada: `flutter run --profile --dart-define=DATOS=simulados`,
  /// elegir «Doscientos reportes» en el matraz y mirar DevTools.
  List<Reporte> _doscientos() {
    const List<String> lugares = <String>[
      'Lote de la calle 52',
      'Orilla del caño',
      'Separador de la avenida',
      'Esquina del colegio',
      'Detrás del salón comunal',
    ];
    return List<Reporte>.generate(200, (int i) {
      return Reporte(
        id: 1000 + i,
        fecha: _ahora.subtract(Duration(hours: 3 * i + 1)),
        referencia: '${lugares[i % lugares.length]} · prueba ${i + 1}',
        latitud: 7.0600 + (i % 50) / 10000,
        longitud: -73.8500 - (i % 40) / 10000,
        precisionMetros: 5.0 + i % 70,
      );
    });
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
