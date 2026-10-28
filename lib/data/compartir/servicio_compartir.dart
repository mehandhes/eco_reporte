import 'dart:io';

import 'package:share_plus/share_plus.dart';

/// HU-10 · Cómo terminó el intento de compartir.
enum ResultadoCompartir {
  /// La vecina eligió una app (WhatsApp u otra).
  compartido,

  /// Cerró el menú sin elegir nada.
  cancelado,

  /// El teléfono no pudo abrir el menú de compartir.
  fallido,
}

/// HU-10 · Abre el menú de compartir del teléfono. El ViewModel solo conoce
/// este contrato; las pruebas usan uno falso.
abstract interface class ServicioCompartir {
  Future<ResultadoCompartir> compartir({
    required String texto,
    String? rutaFoto,
  });
}

/// [ServicioCompartir] real, con `share_plus`.
///
/// No se apunta a WhatsApp directamente: el menú del sistema lo muestra si
/// está instalado y, si no, ofrece cualquier otra app (escenario «WhatsApp
/// no está instalado»). Sin conexión, WhatsApp guarda el mensaje y lo envía
/// cuando vuelva la señal; la app no tiene que hacer nada.
class ServicioCompartirSharePlus implements ServicioCompartir {
  @override
  Future<ResultadoCompartir> compartir({
    required String texto,
    String? rutaFoto,
  }) async {
    final bool hayFoto = rutaFoto != null && await File(rutaFoto).exists();
    try {
      final ShareResult resultado = await SharePlus.instance.share(
        ShareParams(
          text: texto,
          files: hayFoto
              ? <XFile>[XFile(rutaFoto, mimeType: 'image/jpeg')]
              : null,
        ),
      );
      return switch (resultado.status) {
        ShareResultStatus.success => ResultadoCompartir.compartido,
        ShareResultStatus.dismissed => ResultadoCompartir.cancelado,
        // «unavailable»: la plataforma no informa qué pasó. El menú sí se
        // abrió, así que se trata como compartido.
        ShareResultStatus.unavailable => ResultadoCompartir.compartido,
      };
    } catch (_) {
      return ResultadoCompartir.fallido;
    }
  }
}
