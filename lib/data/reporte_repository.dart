import '../domain/reporte.dart';

/// De dónde salen los reportes. La interfaz y los ViewModel solo conocen
/// este contrato: cuando llegue el repositorio SQLite (TEC-02) se cambia la
/// implementación en `main.dart` y ninguna pantalla se entera.
abstract interface class ReporteRepository {
  /// Todos los reportes, del más reciente al más antiguo (HU-04).
  Future<List<Reporte>> obtenerTodos();
}

/// Los reportes guardados no se pudieron leer.
class ErrorDeLectura implements Exception {
  const ErrorDeLectura([this.detalle = '']);

  final String detalle;

  @override
  String toString() => 'ErrorDeLectura: $detalle';
}
