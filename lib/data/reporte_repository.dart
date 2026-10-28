import '../domain/reporte.dart';

/// De dónde salen y a dónde van los reportes. La interfaz y los ViewModel
/// solo conocen este contrato: en el Sprint 2 (TEC-02) el repositorio
/// simulado se cambió por el de SQLite en `main.dart` y ninguna pantalla se
/// enteró.
abstract interface class ReporteRepository {
  /// Todos los reportes, del más reciente al más antiguo (HU-04).
  /// Lanza [ErrorDeLectura] si no se pueden leer.
  Future<List<Reporte>> obtenerTodos();

  /// Guarda un borrador y devuelve el reporte con el id asignado (HU-03).
  /// Lanza [ErrorDeGuardado] si no se pudo escribir.
  Future<Reporte> guardar(BorradorReporte borrador);

  /// Anota que el reporte [id] se compartió en [cuando] (HU-10) y devuelve
  /// el reporte actualizado. Lanza [ErrorDeGuardado] si no se pudo.
  Future<Reporte> marcarCompartido(int id, DateTime cuando);
}

/// Los reportes guardados no se pudieron leer.
class ErrorDeLectura implements Exception {
  const ErrorDeLectura([this.detalle = '']);

  final String detalle;

  @override
  String toString() => 'ErrorDeLectura: $detalle';
}

/// El reporte no se pudo escribir en la base.
class ErrorDeGuardado implements Exception {
  const ErrorDeGuardado([this.detalle = '']);

  final String detalle;

  @override
  String toString() => 'ErrorDeGuardado: $detalle';
}
