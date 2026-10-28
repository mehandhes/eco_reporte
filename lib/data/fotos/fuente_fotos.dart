/// HU-01 · De dónde sale la foto del punto crítico.
///
/// El ViewModel solo conoce este contrato. En el teléfono lo cumple
/// [FuenteFotosImagePicker]; en las pruebas, una clase falsa que responde
/// lo que la prueba necesite (foto, cancelación, permiso negado…).
abstract interface class FuenteFotos {
  /// Abre la cámara del teléfono.
  Future<ResultadoFoto> tomar();

  /// Abre el selector de fotos del sistema (no pide permiso de galería).
  Future<ResultadoFoto> elegirDeGaleria();

  /// Android puede cerrar la app mientras la cámara está abierta (poca
  /// memoria, una llamada larga). Al volver, la foto tomada se recupera
  /// aquí. Nulo si no había nada pendiente.
  Future<String?> recuperarPerdida();
}

/// Los cuatro finales posibles de pedir una foto. Es `sealed`: un `switch`
/// sobre él tiene que cubrirlos todos o no compila.
sealed class ResultadoFoto {
  const ResultadoFoto();
}

/// Hay foto. [ruta] es un archivo temporal: se copia a la carpeta de la
/// app solo al guardar el reporte (HU-03).
class FotoTomada extends ResultadoFoto {
  const FotoTomada(this.ruta);
  final String ruta;
}

/// La vecina cerró la cámara sin tomar la foto.
class FotoCancelada extends ResultadoFoto {
  const FotoCancelada();
}

/// La vecina negó el permiso de cámara.
class CamaraDenegada extends ResultadoFoto {
  const CamaraDenegada();
}

/// Algo más falló (no hay cámara, error del sistema).
class FotoFallida extends ResultadoFoto {
  const FotoFallida(this.detalle);
  final String detalle;
}
