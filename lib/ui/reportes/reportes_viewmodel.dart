import 'package:flutter/foundation.dart';

import '../../data/reporte_repository.dart';
import '../../domain/reporte.dart';

/// Los cuatro estados de toda lista (Definición de Terminado del curso).
enum EstadoUi { cargando, vacio, error, listo }

/// ViewModel de «Mis reportes» (HU-04) y fuente del detalle (HU-05).
///
/// La pantalla solo lee y pide: nunca habla con el repositorio.
class ReportesViewModel extends ChangeNotifier {
  ReportesViewModel(this._repositorio);

  final ReporteRepository _repositorio;

  EstadoUi _estado = EstadoUi.cargando;
  List<Reporte> _reportes = const <Reporte>[];

  /// Cuenta las cargas para descartar la respuesta de una carga vieja si
  /// mientras tanto se pidió otra (por ejemplo, dos «Reintentar» seguidos).
  int _cargaActual = 0;
  bool _cerrado = false;

  EstadoUi get estado => _estado;
  List<Reporte> get reportes => _reportes;

  Future<void> cargar() async {
    final int estaCarga = ++_cargaActual;
    if (_estado != EstadoUi.cargando) {
      _estado = EstadoUi.cargando;
      _avisar();
    }

    try {
      final List<Reporte> lista = await _repositorio.obtenerTodos();
      if (estaCarga != _cargaActual) return;
      _reportes = List<Reporte>.unmodifiable(lista);
      _estado = lista.isEmpty ? EstadoUi.vacio : EstadoUi.listo;
    } catch (e) {
      if (estaCarga != _cargaActual) return;
      _reportes = const <Reporte>[];
      _estado = EstadoUi.error;
      debugPrint('No se pudieron leer los reportes: $e');
    }
    _avisar();
  }

  /// HU-05: el detalle sale de lo que la lista ya cargó.
  Reporte? buscar(int id) {
    for (final Reporte reporte in _reportes) {
      if (reporte.id == id) return reporte;
    }
    return null;
  }

  void _avisar() {
    if (!_cerrado) notifyListeners();
  }

  @override
  void dispose() {
    _cerrado = true;
    super.dispose();
  }
}
