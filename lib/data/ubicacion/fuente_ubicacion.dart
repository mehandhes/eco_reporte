/// HU-02 · De dónde sale la ubicación del punto.
///
/// El ViewModel solo conoce este contrato; el GPS real lo pone
/// [FuenteUbicacionGeolocator] y las pruebas usan uno falso.
///
/// RC-06: la ubicación se pide **una vez, mientras se llena el reporte**.
/// No hay seguimiento ni segundo plano.
abstract interface class FuenteUbicacion {
  /// Pide el permiso si hace falta y devuelve la posición actual.
  Future<ResultadoUbicacion> obtener();

  /// Abre los ajustes de la app (permiso bloqueado para siempre).
  Future<void> abrirAjustesDeLaApp();

  /// Abre los ajustes de ubicación del teléfono (GPS apagado).
  Future<void> abrirAjustesDeUbicacion();
}

/// Los finales posibles de pedir la ubicación. Cada uno se le explica a la
/// vecina de forma distinta, por eso no basta con «hay» o «no hay».
sealed class ResultadoUbicacion {
  const ResultadoUbicacion();
}

class UbicacionObtenida extends ResultadoUbicacion {
  const UbicacionObtenida({
    required this.latitud,
    required this.longitud,
    required this.precisionMetros,
  });

  final double latitud;
  final double longitud;

  /// Radio de error estimado por el sistema, en metros.
  final double precisionMetros;
}

/// La vecina negó el permiso. Si [bloqueado], Android ya no vuelve a
/// preguntar: solo se puede cambiar en los ajustes de la app.
class SinPermisoDeUbicacion extends ResultadoUbicacion {
  const SinPermisoDeUbicacion({required this.bloqueado});
  final bool bloqueado;
}

/// El GPS del teléfono está apagado.
class GpsApagado extends ResultadoUbicacion {
  const GpsApagado();
}

/// Había permiso, pero la posición no llegó a tiempo (bajo techo, sin
/// cielo despejado).
class SinSenalGps extends ResultadoUbicacion {
  const SinSenalGps();
}
