/// Un reporte ciudadano de un punto crítico de residuos, ya guardado.
///
/// Es inmutable: nada cambia por debajo mientras la interfaz lo dibuja.
/// Sprint 2 · TEC-02: aprende a convertirse en una fila de SQLite y a
/// reconstruirse desde ella (`aFila` / `desdeFila`).
class Reporte {
  const Reporte({
    required this.id,
    required this.fecha,
    required this.referencia,
    this.latitud,
    this.longitud,
    this.precisionMetros,
    this.rutaFoto,
    this.compartidoEn,
  });

  /// Lo asigna SQLite al guardar. Un reporte sin id todavía es un
  /// [BorradorReporte].
  final int id;
  final DateTime fecha;

  /// Referencia del lugar escrita por la vecina (HU-12): «frente a la cancha».
  /// Puede estar vacía si hay coordenadas.
  final String referencia;

  /// Nulas cuando la vecina negó el permiso de ubicación (HU-02).
  final double? latitud;
  final double? longitud;

  /// Precisión estimada del GPS, en metros.
  final double? precisionMetros;

  /// Ruta de la foto en la carpeta privada de la app. Nunca una ruta
  /// temporal: la foto se copia antes de guardar el reporte (HU-03).
  /// Nula solo en los datos simulados.
  final String? rutaFoto;

  /// Cuándo se compartió por última vez (HU-10). Nulo si nunca.
  /// Nació del hallazgo heurístico H1: la lista debe mostrar que ya se
  /// compartió.
  final DateTime? compartidoEn;

  bool get fueCompartido => compartidoEn != null;

  /// Copia del reporte marcada como compartida en [cuando].
  Reporte compartido(DateTime cuando) => Reporte(
        id: id,
        fecha: fecha,
        referencia: referencia,
        latitud: latitud,
        longitud: longitud,
        precisionMetros: precisionMetros,
        rutaFoto: rutaFoto,
        compartidoEn: cuando,
      );

  bool get tieneUbicacion => latitud != null && longitud != null;

  /// HU-02: una precisión peor que 50 m se avisa, no se oculta.
  bool get ubicacionAproximada =>
      precisionMetros != null && precisionMetros! > 50;

  // ----------------------------------------------------------------------
  // TEC-02 · Conversión a fila de SQLite y de vuelta.
  //
  // SQLite solo entiende int, double, String, bytes y null. La fecha viaja
  // como milisegundos desde 1970 (un entero): ordena bien y no depende de
  // la zona horaria con que se escriba.
  // ----------------------------------------------------------------------

  /// La fila completa, con su id.
  Map<String, Object?> aFila() => <String, Object?>{
        'id': id,
        ...camposDeFila(
          fecha: fecha,
          referencia: referencia,
          latitud: latitud,
          longitud: longitud,
          precisionMetros: precisionMetros,
          rutaFoto: rutaFoto,
        ),
        'compartido_ms': compartidoEn?.millisecondsSinceEpoch,
      };

  /// Reconstruye un reporte a partir de una fila de la tabla `reportes`.
  factory Reporte.desdeFila(Map<String, Object?> fila) {
    return Reporte(
      id: fila['id']! as int,
      fecha: DateTime.fromMillisecondsSinceEpoch(fila['fecha_ms']! as int),
      referencia: (fila['referencia'] as String?) ?? '',
      latitud: (fila['latitud'] as num?)?.toDouble(),
      longitud: (fila['longitud'] as num?)?.toDouble(),
      precisionMetros: (fila['precision_m'] as num?)?.toDouble(),
      rutaFoto: fila['ruta_foto'] as String?,
      compartidoEn: switch (fila['compartido_ms']) {
        final int ms => DateTime.fromMillisecondsSinceEpoch(ms),
        _ => null,
      },
    );
  }

  /// Las columnas que comparten un reporte y un borrador (todas menos el id).
  static Map<String, Object?> camposDeFila({
    required DateTime fecha,
    required String referencia,
    double? latitud,
    double? longitud,
    double? precisionMetros,
    String? rutaFoto,
  }) =>
      <String, Object?>{
        'fecha_ms': fecha.millisecondsSinceEpoch,
        'referencia': referencia,
        'latitud': latitud,
        'longitud': longitud,
        'precision_m': precisionMetros,
        'ruta_foto': rutaFoto,
      };
}

/// Lo que el formulario «Nuevo reporte» entrega para guardar: un reporte
/// que todavía no tiene id. Separarlo de [Reporte] evita los `id!` y los
/// id falsos (0, -1) repartidos por la app.
class BorradorReporte {
  const BorradorReporte({
    required this.fecha,
    required this.referencia,
    required this.rutaFoto,
    this.latitud,
    this.longitud,
    this.precisionMetros,
  });

  final DateTime fecha;
  final String referencia;

  /// Ruta permanente de la foto (ya copiada a la carpeta de la app).
  final String rutaFoto;
  final double? latitud;
  final double? longitud;
  final double? precisionMetros;

  Map<String, Object?> aFila() => Reporte.camposDeFila(
        fecha: fecha,
        referencia: referencia,
        latitud: latitud,
        longitud: longitud,
        precisionMetros: precisionMetros,
        rutaFoto: rutaFoto,
      );

  /// El reporte que resulta de guardarlo con el id que asignó la base.
  Reporte conId(int id) => Reporte(
        id: id,
        fecha: fecha,
        referencia: referencia,
        latitud: latitud,
        longitud: longitud,
        precisionMetros: precisionMetros,
        rutaFoto: rutaFoto,
      );
}
