import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'servicio_compartir.dart';

/// HU-09 · Escribe el listado del mes en un archivo y abre el menú de
/// compartir del teléfono con ese archivo adjunto.
///
/// La presidenta de la JAC elige a dónde va: WhatsApp, correo, Drive o
/// «Guardar en el teléfono». La app no sube nada a ningún servidor (RC-06).
abstract interface class ServicioExportar {
  Future<ResultadoCompartir> exportar({
    required String nombreArchivo,
    required String contenido,
    required String texto,
  });
}

/// [ServicioExportar] real, con `share_plus`.
class ServicioExportarSharePlus implements ServicioExportar {
  /// [carpeta] se inyecta en las pruebas; en el teléfono es la carpeta
  /// temporal de la app, que Android limpia solo cuando necesita espacio.
  ServicioExportarSharePlus({Future<Directory> Function()? carpeta})
      : _carpeta = carpeta ?? getTemporaryDirectory;

  final Future<Directory> Function() _carpeta;

  /// Escribe [contenido] en un archivo nuevo y devuelve su ruta. Si ya
  /// había un listado del mismo mes, lo reemplaza: siempre sale el último.
  Future<File> escribir(String nombreArchivo, String contenido) async {
    final Directory carpeta = await _carpeta();
    final File archivo = File(p.join(carpeta.path, nombreArchivo));
    return archivo.writeAsString(contenido, flush: true);
  }

  @override
  Future<ResultadoCompartir> exportar({
    required String nombreArchivo,
    required String contenido,
    required String texto,
  }) async {
    try {
      final File archivo = await escribir(nombreArchivo, contenido);
      final ShareResult resultado = await SharePlus.instance.share(
        ShareParams(
          text: texto,
          subject: texto,
          files: <XFile>[XFile(archivo.path, mimeType: 'text/csv')],
        ),
      );
      return switch (resultado.status) {
        ShareResultStatus.success => ResultadoCompartir.compartido,
        ShareResultStatus.dismissed => ResultadoCompartir.cancelado,
        ShareResultStatus.unavailable => ResultadoCompartir.compartido,
      };
    } catch (_) {
      return ResultadoCompartir.fallido;
    }
  }
}
