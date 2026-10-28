import 'package:eco_reporte/domain/listado_mes.dart';
import 'package:eco_reporte/domain/reporte.dart';
import 'package:flutter_test/flutter_test.dart';

/// HU-09 · El listado del mes, comprobado como texto: lo que abrirá la
/// empresa de aseo en Excel.
void main() {
  final Reporte octubreTarde = Reporte(
    id: 2,
    fecha: DateTime(2026, 10, 30, 19, 5),
    referencia: 'Frente a la cancha; junto al poste',
    latitud: 7.065312,
    longitud: -73.854718,
    precisionMetros: 8.4,
    categoria: Categoria.escombros,
    compartidoEn: DateTime(2026, 10, 30, 19, 10),
  );
  final Reporte octubreTemprano = Reporte(
    id: 1,
    fecha: DateTime(2026, 10, 2, 7, 30),
    referencia: 'Esquina del colegio',
  );
  final Reporte noviembre = Reporte(
    id: 3,
    fecha: DateTime(2026, 11, 1, 6),
    referencia: 'Orilla del caño',
  );
  final List<Reporte> todos = <Reporte>[noviembre, octubreTarde, octubreTemprano];

  List<String> lineas(String csv) => csv.substring(1).trimRight().split('\r\n');

  test('los meses con reportes van del más reciente al más antiguo', () {
    expect(mesesConReportes(todos), <DateTime>[DateTime(2026, 11), DateTime(2026, 10)]);
    expect(mesesConReportes(<Reporte>[]), isEmpty);
  });

  test('el mes trae solo sus reportes, del más antiguo al más reciente', () {
    final List<Reporte> octubre = reportesDelMes(todos, DateTime(2026, 10));

    expect(octubre.map((Reporte r) => r.id), <int>[1, 2]);
  });

  test('el nombre del archivo ordena por año y mes', () {
    expect(nombreDelListado(DateTime(2026, 3)), 'ecoreporte_2026-03.csv');
  });

  test('empieza con BOM y trae el encabezado y una fila por reporte', () {
    final String csv = componerListadoCsv(<Reporte>[octubreTemprano, octubreTarde]);

    expect(csv.codeUnitAt(0), 0xFEFF, reason: 'sin BOM, Excel daña las tildes');
    final List<String> filas = lineas(csv);
    expect(filas, hasLength(3));
    expect(filas.first, columnasDelListado.join(';'));
  });

  test('una fila con GPS: fecha, hora, tipo, coordenadas en una celda y mapa', () {
    final String fila = lineas(componerListadoCsv(<Reporte>[octubreTarde]))[1];

    expect(
      fila,
      '1;30/10/2026;19:05;Escombros;"Frente a la cancha; junto al poste";'
      '7.06531, -73.85472;8;'
      'https://www.google.com/maps/search/?api=1&query=7.06531%2C-73.85472;Sí',
    );
  });

  test('sin GPS ni tipo: «Sin GPS», «Sin clasificar» y celdas vacías', () {
    final String fila = lineas(componerListadoCsv(<Reporte>[octubreTemprano]))[1];

    expect(fila, '1;02/10/2026;07:30;Sin clasificar;Esquina del colegio;Sin GPS;;;No');
  });

  test('una referencia que parece fórmula se exporta como texto (CSV injection)', () {
    final Reporte malicioso = Reporte(
      id: 9,
      fecha: DateTime(2026, 10, 5),
      referencia: '=HYPERLINK("http://x.example","Clic")',
    );

    final String fila = lineas(componerListadoCsv(<Reporte>[malicioso]))[1];

    expect(fila, contains(';"\'=HYPERLINK(""http://x.example"",""Clic"")";'));
  });

  test('un salto de línea en la referencia no parte la fila', () {
    final Reporte conSalto = Reporte(
      id: 4,
      fecha: DateTime(2026, 10, 6),
      referencia: 'Detrás del salón\ncomunal',
    );

    final String csv = componerListadoCsv(<Reporte>[conSalto]);

    expect(csv, contains('"Detrás del salón\ncomunal"'));
  });
}
