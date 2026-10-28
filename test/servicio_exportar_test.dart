import 'dart:convert';
import 'dart:io';

import 'package:eco_reporte/data/compartir/servicio_exportar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

/// HU-09 · El archivo del listado se escribe en UTF-8, con su BOM, y el del
/// mismo mes se reemplaza. El menú de compartir se prueba en el teléfono.
void main() {
  late Directory raiz;
  late ServicioExportarSharePlus servicio;

  setUp(() async {
    raiz = await Directory.systemTemp.createTemp('eco_listado_');
    servicio = ServicioExportarSharePlus(carpeta: () async => raiz);
  });

  tearDown(() => raiz.delete(recursive: true));

  test('escribe el archivo en UTF-8 con BOM, y las tildes sobreviven', () async {
    final File archivo =
        await servicio.escribir('ecoreporte_2026-10.csv', '﻿N.º;Lugar\r\n1;Caño\r\n');

    expect(p.basename(archivo.path), 'ecoreporte_2026-10.csv');
    final List<int> bytes = await archivo.readAsBytes();
    expect(bytes.take(3), <int>[0xEF, 0xBB, 0xBF], reason: 'BOM de UTF-8');
    expect(utf8.decode(bytes.skip(3).toList()), 'N.º;Lugar\r\n1;Caño\r\n');
  });

  test('exportar dos veces el mismo mes deja solo el último', () async {
    await servicio.escribir('ecoreporte_2026-10.csv', 'viejo');
    await servicio.escribir('ecoreporte_2026-10.csv', 'nuevo');

    expect(raiz.listSync(), hasLength(1));
    expect(await File(p.join(raiz.path, 'ecoreporte_2026-10.csv')).readAsString(), 'nuevo');
  });
}
