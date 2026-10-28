import 'dart:io';

import 'package:eco_reporte/data/fotos/almacen_fotos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

/// HU-03 · La foto se copia a la carpeta de la app antes de guardar.
void main() {
  late Directory raiz;
  late AlmacenFotosLocal almacen;

  setUp(() async {
    raiz = await Directory.systemTemp.createTemp('eco_reporte_');
    almacen = AlmacenFotosLocal(carpetaBase: () async => raiz);
  });

  tearDown(() => raiz.delete(recursive: true));

  test('copia la foto temporal a fotos/ y la temporal puede desaparecer', () async {
    final File temporal = File(p.join(raiz.path, 'cache', 'image_picker_123.jpg'));
    await temporal.create(recursive: true);
    await temporal.writeAsBytes(<int>[1, 2, 3, 4]);

    final String ruta = await almacen.guardarPermanente(temporal.path);
    await temporal.delete(); // el sistema limpia la caché cuando quiere

    expect(p.dirname(ruta), p.join(raiz.path, 'fotos'));
    expect(p.extension(ruta), '.jpg');
    expect(await File(ruta).readAsBytes(), <int>[1, 2, 3, 4]);
  });

  test('borrar quita la copia, y borrar algo que no existe no falla', () async {
    final File temporal = File(p.join(raiz.path, 'a.jpg'));
    await temporal.writeAsBytes(<int>[9]);
    final String ruta = await almacen.guardarPermanente(temporal.path);

    await almacen.borrar(ruta);
    await almacen.borrar(ruta);

    expect(await File(ruta).exists(), isFalse);
  });

  test('una foto temporal que ya no existe no deja copias a medias', () async {
    await expectLater(
      almacen.guardarPermanente(p.join(raiz.path, 'no_existe.jpg')),
      throwsA(isA<FileSystemException>()),
    );
    final Directory fotos = Directory(p.join(raiz.path, 'fotos'));
    expect(await fotos.list().isEmpty, isTrue);
  });
}
