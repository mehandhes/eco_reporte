import 'package:flutter/foundation.dart';

import '../../data/compartir/servicio_compartir.dart';
import '../../data/reporte_repository.dart';
import '../../domain/mensaje_compartir.dart';
import '../../domain/reporte.dart';
import '../comun/formatos.dart';

/// Los cuatro estados de toda lista (Definición de Terminado del curso).
enum EstadoUi { cargando, vacio, error, listo }

/// ViewModel de «Mis reportes» (HU-04) y fuente del detalle (HU-05).
/// Desde el Sprint 3 también comparte un reporte (HU-10).
///
/// La pantalla solo lee y pide: nunca habla con el repositorio.
class ReportesViewModel extends ChangeNotifier {
  ReportesViewModel(
    this._repositorio, {
    required ServicioCompartir compartir,
    DateTime Function()? reloj,
  })  : _compartir = compartir,
        _reloj = reloj ?? DateTime.now;

  final ReporteRepository _repositorio;
  final ServicioCompartir _compartir;
  final DateTime Function() _reloj;

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

  /// HU-03 · Un reporte recién guardado aparece de primero sin volver a
  /// leer la base: es el más reciente.
  void agregar(Reporte nuevo) {
    _reportes = List<Reporte>.unmodifiable(<Reporte>[nuevo, ..._reportes]);
    _estado = EstadoUi.listo;
    _avisar();
  }

  /// HU-05: el detalle sale de lo que la lista ya cargó.
  Reporte? buscar(int id) {
    for (final Reporte reporte in _reportes) {
      if (reporte.id == id) return reporte;
    }
    return null;
  }

  // ---------------------------------------------------------------- HU-10
  int? _compartiendo;

  /// Id del reporte que se está compartiendo, para apagar su botón.
  bool compartiendo(int id) => _compartiendo == id;

  /// Abre el menú de compartir con la foto y el mensaje del reporte [id].
  /// Si la vecina eligió una app, el reporte queda marcado como compartido
  /// (hallazgo H1) y la lista lo muestra.
  Future<ResultadoCompartir> compartir(int id) async {
    final Reporte? reporte = buscar(id);
    if (reporte == null || _compartiendo != null) {
      return ResultadoCompartir.cancelado;
    }
    _compartiendo = id;
    _avisar();

    final ResultadoCompartir resultado = await _compartir.compartir(
      texto: componerMensaje(reporte, formatearFecha: formatearFechaYHora),
      rutaFoto: reporte.rutaFoto,
    );

    if (resultado == ResultadoCompartir.compartido) {
      try {
        final Reporte marcado =
            await _repositorio.marcarCompartido(id, _reloj());
        _reemplazar(marcado);
      } catch (e) {
        // El mensaje ya salió: no marcarlo no es motivo para asustar a la
        // vecina con un error.
        debugPrint('No se pudo marcar como compartido: $e');
      }
    }
    _compartiendo = null;
    _avisar();
    return resultado;
  }

  void _reemplazar(Reporte actualizado) {
    _reportes = List<Reporte>.unmodifiable(<Reporte>[
      for (final Reporte r in _reportes) r.id == actualizado.id ? actualizado : r,
    ]);
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
