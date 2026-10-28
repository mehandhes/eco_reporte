import 'package:geolocator/geolocator.dart';

import 'fuente_ubicacion.dart';

/// [FuenteUbicacion] real, con el paquete `geolocator`.
class FuenteUbicacionGeolocator implements FuenteUbicacion {
  /// HU-02 · «veo la ubicación del punto en menos de 10 segundos». Pasado
  /// ese tiempo se avisa, en lugar de dejar la pantalla esperando.
  static const Duration limite = Duration(seconds: 10);

  @override
  Future<ResultadoUbicacion> obtener() async {
    // 1. ¿El GPS está encendido?
    if (!await Geolocator.isLocationServiceEnabled()) {
      return const GpsApagado();
    }

    // 2. ¿Hay permiso? Si nunca se pidió, se pide ahora. Android 12 o más
    //    muestra «precisa» o «aproximada»: las dos sirven; la aproximada
    //    llegará con más de 50 m de error y se avisará.
    LocationPermission permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }
    switch (permiso) {
      case LocationPermission.denied:
      case LocationPermission.unableToDetermine:
        return const SinPermisoDeUbicacion(bloqueado: false);
      case LocationPermission.deniedForever:
        return const SinPermisoDeUbicacion(bloqueado: true);
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        break;
    }

    // 3. Con permiso: una sola lectura, con límite de tiempo. Sin límite,
    //    dentro de una casa esto puede quedarse esperando para siempre.
    try {
      final Position posicion = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: limite,
        ),
      );
      return UbicacionObtenida(
        latitud: posicion.latitude,
        longitud: posicion.longitude,
        precisionMetros: posicion.accuracy,
      );
    } catch (_) {
      // TimeoutException o un error del sistema: para la vecina es lo
      // mismo, la señal no llegó.
      return const SinSenalGps();
    }
  }

  @override
  Future<void> abrirAjustesDeLaApp() async {
    await Geolocator.openAppSettings();
  }

  @override
  Future<void> abrirAjustesDeUbicacion() async {
    await Geolocator.openLocationSettings();
  }
}
