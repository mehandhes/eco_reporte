import 'dart:async';

import 'package:eco_reporte/data/fotos/almacen_fotos.dart';
import 'package:eco_reporte/data/fotos/fuente_fotos.dart';
import 'package:eco_reporte/data/reporte_repository.dart';
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
}
