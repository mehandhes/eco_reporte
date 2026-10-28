import 'package:flutter/foundation.dart';

import '../../data/compartir/servicio_compartir.dart';
import '../../data/compartir/servicio_exportar.dart';
import '../../data/fotos/almacen_fotos.dart';
import '../../data/reporte_repository.dart';
import '../../domain/listado_mes.dart';
import '../../domain/mensaje_compartir.dart';
import '../../domain/reporte.dart';
import '../comun/formatos.dart';

/// Los cuatro estados de toda lista (Definición de Terminado del curso).
enum EstadoUi { cargando, vacio, error, listo }

/// ViewModel de «Mis reportes» (HU-04) y fuente del detalle (HU-05).
/// Desde el Sprint 3 también comparte un reporte (HU-10), y desde el
/// Sprint 5 exporta el listado del mes (HU-09).
///
/// La pantalla solo lee y pide: nunca habla con el repositorio.
class ReportesViewModel extends ChangeNotifier {
  ReportesViewModel(
    this._repositorio, {
    required this._compartir,
    required this._almacen,
    required this._exportar,
    DateTime Function()? reloj,
  }) : _reloj = reloj ?? DateTime.now;

  final ReporteRepository _repositorio;
  final ServicioCompartir _compartir;
  final ServicioExportar _exportar;
  final AlmacenFotos _almacen;
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

  // ---------------------------------------------------------------- HU-09
  bool _exportando = false;

  /// Hay un listado preparándose: el botón se apaga.
  bool get exportando => _exportando;

  /// Los meses que se pueden exportar, del más reciente al más antiguo.
  List<DateTime> get mesesExportables => mesesConReportes(_reportes);

  /// Cuántos reportes tiene [mes].
  int cuantosEn(DateTime mes) => reportesDelMes(_reportes, mes).length;

  /// Arma el listado de [mes] y abre el menú de compartir con el archivo.
  /// Un mes sin reportes no produce un archivo vacío: devuelve cancelado.
  Future<ResultadoCompartir> exportarMes(DateTime mes) async {
    final List<Reporte> delMes = reportesDelMes(_reportes, mes);
    if (delMes.isEmpty || _exportando) return ResultadoCompartir.cancelado;
    _exportando = true;
    _avisar();

    ResultadoCompartir resultado;
    try {
      final int n = delMes.length;
      resultado = await _exportar.exportar(
        nombreArchivo: nombreDelListado(mes),
        contenido: componerListadoCsv(delMes),
        texto: 'Puntos críticos de basura · ${formatearMes(mes)} · '
            '$n ${n == 1 ? 'reporte' : 'reportes'} (EcoReporte)',
      );
    } catch (e) {
      debugPrint('No se pudo exportar el listado: $e');
      resultado = ResultadoCompartir.fallido;
    }
    _exportando = false;
    _avisar();
    return resultado;
  }

  // ---------------------------------------------------------------- TEC-05
  /// Borra el reporte [id] y su foto del teléfono (derecho a suprimir de la
  /// Ley 1581 de 2012). Devuelve falso si no se pudo borrar.
  Future<bool> eliminar(int id) async {
    final Reporte? reporte = buscar(id);
    if (reporte == null) return false;
    try {
      await _repositorio.eliminar(id);
    } catch (e) {
      debugPrint('No se pudo borrar el reporte: $e');
      return false;
    }
    // Primero la fila y después la foto: si la app se cierra en medio,
    // queda una foto huérfana (invisible), nunca un reporte sin foto.
    if (reporte.rutaFoto != null) await _almacen.borrar(reporte.rutaFoto!);
    _reportes = List<Reporte>.unmodifiable(
      _reportes.where((Reporte r) => r.id != id),
    );
    if (_reportes.isEmpty) _estado = EstadoUi.vacio;
    _avisar();
    return true;
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
