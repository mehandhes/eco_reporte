/// Un reporte ciudadano de un punto crítico de residuos.
///
/// Sprint 1 · INV-04: solo los campos que necesitan HU-04 (lista) y HU-05
/// (detalle). La foto real llega con HU-01 y el guardado con TEC-02 / HU-03.
/// Es inmutable: nada cambia por debajo mientras la interfaz lo dibuja.
class Reporte {
  const Reporte({
    required this.id,
    required this.fecha,
    required this.referencia,
    this.latitud,
    this.longitud,
    this.precisionMetros,
    this.rutaFoto,
  });

  final int id;
  final DateTime fecha;

  /// Referencia del lugar escrita por la vecina (HU-12): «frente a la cancha».
  final String referencia;

  /// Nulas cuando la vecina negó el permiso de ubicación (HU-02).
  final double? latitud;
  final double? longitud;

  /// Precisión estimada del GPS, en metros.
  final double? precisionMetros;

  /// Ruta de la foto en el almacenamiento de la app. Nula en los datos
  /// simulados del Sprint 1.
  final String? rutaFoto;

  bool get tieneUbicacion => latitud != null && longitud != null;

  /// HU-02: una precisión peor que 50 m se avisa, no se oculta.
  bool get ubicacionAproximada =>
      precisionMetros != null && precisionMetros! > 50;
}
