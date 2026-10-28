import 'dart:async';

import 'package:eco_reporte/data/fotos/fuente_fotos.dart';

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
