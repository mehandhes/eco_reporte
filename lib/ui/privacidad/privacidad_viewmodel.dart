import 'package:flutter/foundation.dart';

import '../../data/preferencias/preferencias_app.dart';

/// TEC-05 · ¿Ya se mostró el aviso de privacidad?
///
/// RC-06 y Ley 1581: antes de pedir un dato personal (foto, ubicación) se
/// informa para qué se usará. Por eso el primer «Reportar» pasa por el
/// aviso, y los siguientes van directo al formulario.
class PrivacidadViewModel extends ChangeNotifier {
  PrivacidadViewModel(this._preferencias);

  final PreferenciasApp _preferencias;
  bool _aceptado = false;

  bool get aceptado => _aceptado;

  Future<void> cargar() async {
    _aceptado = await _preferencias.avisoPrivacidadAceptado();
    notifyListeners();
  }

  Future<void> aceptar() async {
    _aceptado = true;
    notifyListeners();
    await _preferencias.aceptarAvisoPrivacidad();
  }
}
