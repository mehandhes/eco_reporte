import 'dart:io';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// HU-03 · Dónde viven las fotos de los reportes guardados.
///
/// La cámara deja la foto en una carpeta temporal que el sistema puede
/// limpiar cuando quiera. Por eso, al guardar, la foto se copia a la carpeta
/// privada de la app y la base guarda esa ruta, nunca la temporal.
abstract interface class AlmacenFotos {
  /// Copia la foto a la carpeta de la app y devuelve la ruta nueva.
  /// Lanza [SinEspacio] si el teléfono no tiene espacio para ella.
  Future<String> guardarPermanente(String rutaTemporal);

  /// Borra una foto copiada (por ejemplo, si después falló la base).
  Future<void> borrar(String ruta);
}

/// No cupo la foto en el teléfono (HU-03 · «Sin espacio en el teléfono»).
class SinEspacio implements Exception {
  const SinEspacio();

  @override
  String toString() => 'SinEspacio';
}

/// [AlmacenFotos] real, en la carpeta de documentos de la app.
class AlmacenFotosLocal implements AlmacenFotos {
  /// [carpetaBase] se inyecta en las pruebas; en el teléfono es la carpeta
  /// de documentos que da `path_provider`.
  AlmacenFotosLocal({Future<Directory> Function()? carpetaBase})
      : _carpetaBase = carpetaBase ?? getApplicationDocumentsDirectory;

  final Future<Directory> Function() _carpetaBase;

  /// Código del sistema operativo para «no queda espacio» (ENOSPC) en
  /// Android y Linux.
  static const int _sinEspacio = 28;

  @override
  Future<String> guardarPermanente(String rutaTemporal) async {
    final Directory base = await _carpetaBase();
    final Directory carpeta = Directory(p.join(base.path, 'fotos'));
    await carpeta.create(recursive: true);

    final String extension =
        p.extension(rutaTemporal).isEmpty ? '.jpg' : p.extension(rutaTemporal);
    final String marca = DateTime.now().microsecondsSinceEpoch.toString();
    final String destino = p.join(carpeta.path, 'reporte_$marca$extension');

    try {
      final File copia = await File(rutaTemporal).copy(destino);
      // RC-04 · cada foto pesa menos de 1 MB. Se ve en la consola de
      // `flutter run` y se anota en el plan de pruebas.
      final int kb = (await copia.length()) ~/ 1024;
      debugPrint('Foto guardada: $kb KB${kb >= 1024 ? ' (¡supera RC-04!)' : ''}');
      return destino;
    } on FileSystemException catch (e) {
      // Una copia a medias no sirve: se borra antes de avisar.
      await borrar(destino);
      if (e.osError?.errorCode == _sinEspacio) throw const SinEspacio();
      rethrow;
    }
  }

  @override
  Future<void> borrar(String ruta) async {
    try {
      final File archivo = File(ruta);
      if (await archivo.exists()) await archivo.delete();
    } on FileSystemException {
      // Si no se puede borrar, no hay nada más que hacer: no es un error
      // que la vecina pueda resolver.
    }
  }
}
