import 'package:flutter/foundation.dart';

import '../../data/fotos/almacen_fotos.dart';
import '../../data/fotos/fuente_fotos.dart';
import '../../data/reporte_repository.dart';
import '../../domain/reporte.dart';

/// ViewModel del formulario «Nuevo reporte».
///
/// Vive mientras la pantalla está abierta. Si entra una llamada y la app
/// pasa a segundo plano, este objeto sigue en memoria con todo lo llenado
/// (HU-01 · «Una llamada a mitad del formulario»).
class NuevoReporteViewModel extends ChangeNotifier {
  NuevoReporteViewModel({
    required FuenteFotos fotos,
    required AlmacenFotos almacen,
    required ReporteRepository repositorio,
    DateTime Function()? reloj,
  })  : _fotos = fotos,
        _almacen = almacen,
        _repositorio = repositorio,
        _reloj = reloj ?? DateTime.now;

  final FuenteFotos _fotos;
  final AlmacenFotos _almacen;
  final ReporteRepository _repositorio;

  /// Se inyecta para que las pruebas controlen la fecha del reporte.
  final DateTime Function() _reloj;

  // ---------------------------------------------------------------- HU-01
  String? _rutaFoto;
  bool _pidiendoFoto = false;
  bool _camaraDenegada = false;
  String? _avisoFoto;

  /// Ruta temporal de la foto elegida, o nula si todavía no hay.
  String? get rutaFoto => _rutaFoto;
  bool get tieneFoto => _rutaFoto != null;

  /// La cámara o la galería están abiertas: los botones se desactivan.
  bool get pidiendoFoto => _pidiendoFoto;

  /// HU-01 · La vecina negó la cámara: se explica para qué sirve y se
  /// ofrece la galería.
  bool get camaraDenegada => _camaraDenegada;

  /// Mensaje en lenguaje llano si la cámara falló por otra razón.
  String? get avisoFoto => _avisoFoto;

  Future<void> tomarFoto() => _pedirFoto(_fotos.tomar);

  Future<void> elegirDeGaleria() => _pedirFoto(_fotos.elegirDeGaleria);

  Future<void> _pedirFoto(Future<ResultadoFoto> Function() pedir) async {
    if (_pidiendoFoto || _guardando) return;
    _pidiendoFoto = true;
    _avisoFoto = null;
    _avisar();

    ResultadoFoto resultado;
    try {
      resultado = await pedir();
    } catch (e) {
      resultado = FotoFallida('$e');
    }

    switch (resultado) {
      case FotoTomada(:final String ruta):
        _rutaFoto = ruta; // Repetir la foto reemplaza la anterior.
        _camaraDenegada = false;
      case FotoCancelada():
        // HU-01 · «Cancelar no borra lo demás»: no se toca nada.
        break;
      case CamaraDenegada():
        _camaraDenegada = true;
      case FotoFallida(:final String detalle):
        debugPrint('La cámara falló: $detalle');
        _avisoFoto = 'No se pudo abrir la cámara. '
            'Puedes elegir una foto de la galería.';
    }
    _pidiendoFoto = false;
    _avisar();
  }

  /// Al abrir el formulario: si Android cerró la app con la cámara abierta,
  /// recupera la foto que se alcanzó a tomar.
  Future<void> recuperarFotoPerdida() async {
    final String? ruta = await _fotos.recuperarPerdida();
    if (ruta != null && _rutaFoto == null) {
      _rutaFoto = ruta;
      _avisar();
    }
  }

  // ---------------------------------------------------------------- HU-12
  /// Límite de la referencia. Cabe en una línea de WhatsApp y en el
  /// listado de la JAC.
  static const int maxReferencia = 120;

  String _referencia = '';

  /// Se vuelve verdadero la primera vez que se intenta guardar: desde ahí
  /// el formulario señala lo que falta (no antes, para no regañar a quien
  /// apenas está empezando).
  bool _intentoGuardar = false;

  String get referencia => _referencia;
  set referencia(String valor) {
    _referencia = valor;
    _avisar();
  }

  /// HU-12 · Sin ubicación, la referencia es lo único que dirá dónde está
  /// el punto. Hasta que llegue HU-02 (Sprint 3) el formulario no tiene
  /// ubicación, así que la referencia es siempre obligatoria.
  bool get referenciaObligatoria => true;

  bool get faltaReferencia =>
      referenciaObligatoria && _referencia.trim().isEmpty;

  String? get errorReferencia => _intentoGuardar && faltaReferencia
      ? 'Escribe una referencia del lugar: sin ubicación, es lo que '
          'dirá dónde está el punto.'
      : null;

  /// HU-03 · «Falta la foto»: se dice qué falta, junto a la foto.
  String? get errorFoto => _intentoGuardar && !tieneFoto
      ? 'Falta la foto. Tómala o elígela de la galería.'
      : null;

  /// Marca el intento de guardar y dice si el formulario está completo.
  bool validar() {
    _intentoGuardar = true;
    _avisar();
    return tieneFoto && !faltaReferencia;
  }

  // ---------------------------------------------------------------- HU-03
  bool _guardando = false;
  String? _errorGuardado;

  /// Hay un guardado en curso (o ya terminó bien): los botones se apagan.
  bool get guardando => _guardando;

  /// Por qué no se pudo guardar, en lenguaje llano.
  String? get errorGuardado => _errorGuardado;

  /// Guarda el reporte en el teléfono. Devuelve el reporte guardado, o
  /// nulo si no se guardó (falta algo, no hubo espacio, la base falló).
  ///
  /// No necesita conexión: todo pasa dentro del teléfono.
  Future<Reporte?> guardar() async {
    // HU-03 · «Doble toque»: el segundo toque llega con _guardando en
    // verdadero y no hace nada. Se crea un solo reporte.
    if (_guardando) return null;
    if (!validar()) return null;

    _guardando = true;
    _errorGuardado = null;
    _avisar();

    String? rutaPermanente;
    try {
      rutaPermanente = await _almacen.guardarPermanente(_rutaFoto!);
      final Reporte reporte = await _repositorio.guardar(
        BorradorReporte(
          fecha: _reloj(),
          referencia: _referencia.trim(),
          rutaFoto: rutaPermanente,
        ),
      );
      // Queda en «guardando» a propósito: la pantalla se va a cerrar y
      // ningún toque más debe volver a guardar.
      return reporte;
    } on SinEspacio {
      // HU-03 · «Sin espacio»: el formulario conserva foto y referencia.
      _errorGuardado = 'No hay espacio suficiente en el teléfono para '
          'guardar la foto. Libera espacio y vuelve a intentarlo: tu foto '
          'y lo que escribiste siguen aquí.';
    } catch (e) {
      debugPrint('No se pudo guardar el reporte: $e');
      if (rutaPermanente != null) await _almacen.borrar(rutaPermanente);
      _errorGuardado = 'No se pudo guardar el reporte. Vuelve a intentarlo.';
    }
    _guardando = false;
    _avisar();
    return null;
  }

  // ------------------------------------------------------------ comunes
  bool _cerrado = false;

  void _avisar() {
    if (!_cerrado) notifyListeners();
  }

  @override
  void dispose() {
    _cerrado = true;
    super.dispose();
  }
}
