import 'package:shared_preferences/shared_preferences.dart';

/// TEC-05 · Lo poco que la app recuerda de una vez para otra, fuera de los
/// reportes: si la vecina ya leyó el aviso de privacidad.
abstract interface class PreferenciasApp {
  Future<bool> avisoPrivacidadAceptado();
  Future<void> aceptarAvisoPrivacidad();
}

/// [PreferenciasApp] real, con `shared_preferences` (API asíncrona).
class PreferenciasSharedPreferences implements PreferenciasApp {
  PreferenciasSharedPreferences([SharedPreferencesAsync? almacen])
      : _almacen = almacen ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _almacen;

  /// Si el aviso cambia de fondo, se sube la versión y se vuelve a mostrar.
  static const String _clave = 'aviso_privacidad_v1';

  @override
  Future<bool> avisoPrivacidadAceptado() async {
    try {
      return await _almacen.getBool(_clave) ?? false;
    } catch (_) {
      // Ante la duda, se vuelve a mostrar el aviso: nunca se salta.
      return false;
    }
  }

  @override
  Future<void> aceptarAvisoPrivacidad() => _almacen.setBool(_clave, true);
}
