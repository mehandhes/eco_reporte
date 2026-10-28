import 'dart:async';

import 'package:eco_reporte/data/compartir/servicio_compartir.dart';
import 'package:eco_reporte/data/fotos/almacen_fotos.dart';
import 'package:eco_reporte/data/fotos/fuente_fotos.dart';
import 'package:eco_reporte/data/reporte_repository.dart';
import 'package:eco_reporte/data/ubicacion/fuente_ubicacion.dart';
import 'package:eco_reporte/domain/reporte.dart';

/// Dobles de prueba compartidos. Responden lo que cada prueba les pida, sin
/// cámara, sin GPS y sin archivos de verdad.

/// Cámara y galería falsas: devuelven el resultado que se les programe.
class FuenteFotosFalsa implements FuenteFotos {
  ResultadoFoto alTomar = const FotoTomada('/tmp/foto_camara.jpg');
  ResultadoFoto alElegir = const FotoTomada('/tmp/foto_galeria.jpg');
  String? perdida;

  int vecesTomar = 0;
  int vecesElegir = 0;

  /// Si no es nulo, la cámara se queda «abierta» hasta completarlo.
  Completer<ResultadoFoto>? camaraAbierta;

  @override
  Future<ResultadoFoto> tomar() {
    vecesTomar++;
    return camaraAbierta?.future ?? Future<ResultadoFoto>.value(alTomar);
  }

  @override
  Future<ResultadoFoto> elegirDeGaleria() async {
    vecesElegir++;
    return alElegir;
  }

  @override
  Future<String?> recuperarPerdida() async => perdida;
}

/// Carpeta de fotos falsa: no copia nada, solo anota.
class AlmacenFotosFalso implements AlmacenFotos {
  /// Si no es nulo, guardarPermanente lo lanza.
  Object? error;
  final List<String> guardadas = <String>[];
  final List<String> borradas = <String>[];

  @override
  Future<String> guardarPermanente(String rutaTemporal) async {
    if (error != null) throw error!;
    final String destino = '/app/fotos/${guardadas.length + 1}.jpg';
    guardadas.add(destino);
    return destino;
  }

  @override
  Future<void> borrar(String ruta) async => borradas.add(ruta);
}

/// Repositorio en memoria, con una puerta para frenar el guardado.
class RepositorioFalso implements ReporteRepository {
  final List<Reporte> reportes = <Reporte>[];
  Object? errorAlGuardar;

  /// Si no es nulo, guardar espera a que se complete (para el doble toque).
  Completer<void>? puerta;

  @override
  Future<List<Reporte>> obtenerTodos() async => List<Reporte>.of(reportes);

  @override
  Future<Reporte> guardar(BorradorReporte borrador) async {
    await puerta?.future;
    if (errorAlGuardar != null) throw errorAlGuardar!;
    final Reporte reporte = borrador.conId(reportes.length + 1);
    reportes.insert(0, reporte);
    return reporte;
  }

  @override
  Future<Reporte> marcarCompartido(int id, DateTime cuando) async {
    final int i = reportes.indexWhere((Reporte r) => r.id == id);
    reportes[i] = reportes[i].compartido(cuando);
    return reportes[i];
  }
}

/// Menú de compartir falso: anota lo que se le pidió compartir.
class ServicioCompartirFalso implements ServicioCompartir {
  ResultadoCompartir resultado = ResultadoCompartir.compartido;
  String? ultimoTexto;
  String? ultimaFoto;
  int veces = 0;

  @override
  Future<ResultadoCompartir> compartir({
    required String texto,
    String? rutaFoto,
  }) async {
    veces++;
    ultimoTexto = texto;
    ultimaFoto = rutaFoto;
    return resultado;
  }
}

/// GPS falso. Por omisión, sin permiso: así la referencia es obligatoria y
/// las pruebas del Sprint 2 siguen valiendo tal cual.
class FuenteUbicacionFalsa implements FuenteUbicacion {
  ResultadoUbicacion resultado = const SinPermisoDeUbicacion(bloqueado: false);
  int veces = 0;
  int ajustesApp = 0;
  int ajustesUbicacion = 0;

  /// Si no es nulo, la búsqueda espera a que se complete.
  Completer<ResultadoUbicacion>? enCurso;

  @override
  Future<ResultadoUbicacion> obtener() {
    veces++;
    return enCurso?.future ?? Future<ResultadoUbicacion>.value(resultado);
  }

  @override
  Future<void> abrirAjustesDeLaApp() async => ajustesApp++;

  @override
  Future<void> abrirAjustesDeUbicacion() async => ajustesUbicacion++;
}

/// Una ubicación buena, en el barrio Primero de Mayo.
const UbicacionObtenida buenaSenal = UbicacionObtenida(
  latitud: 7.06531,
  longitud: -73.85472,
  precisionMetros: 8,
);
