import 'mensaje_compartir.dart';
import 'reporte.dart';

// HU-09 · El listado del mes que la presidenta de la JAC lleva a la
// empresa de aseo.
//
// Como el mensaje de HU-10, son funciones puras: sin Flutter, sin plugins
// y sin archivos. Se prueban solas en `test/listado_mes_test.dart`.

/// Los meses que tienen al menos un reporte, del más reciente al más
/// antiguo. Cada mes es el día 1 a la medianoche.
List<DateTime> mesesConReportes(Iterable<Reporte> reportes) {
  final Set<DateTime> meses = <DateTime>{
    for (final Reporte r in reportes) DateTime(r.fecha.year, r.fecha.month),
  };
  return meses.toList()..sort((DateTime a, DateTime b) => b.compareTo(a));
}

/// Los reportes de [mes], del más antiguo al más reciente: así se leen en
/// papel, como una bitácora.
List<Reporte> reportesDelMes(Iterable<Reporte> reportes, DateTime mes) {
  final List<Reporte> delMes = reportes
      .where((Reporte r) =>
          r.fecha.year == mes.year && r.fecha.month == mes.month)
      .toList();
  delMes.sort((Reporte a, Reporte b) {
    final int porFecha = a.fecha.compareTo(b.fecha);
    return porFecha != 0 ? porFecha : a.id.compareTo(b.id);
  });
  return delMes;
}

/// «ecoreporte_2026-10.csv»: el año primero para que los archivos de
/// varios meses se ordenen solos en la carpeta.
String nombreDelListado(DateTime mes) =>
    'ecoreporte_${mes.year}-${mes.month.toString().padLeft(2, '0')}.csv';

/// Separador de columnas. Punto y coma y no coma: en un computador
/// configurado en español de Colombia, Excel usa la coma para los
/// decimales y el punto y coma para separar columnas.
const String separador = ';';

/// Las columnas del listado, en orden.
const List<String> columnasDelListado = <String>[
  'N.º',
  'Fecha',
  'Hora',
  'Tipo de residuo',
  'Lugar',
  'Coordenadas',
  'Precisión (m)',
  'Mapa',
  'Compartido',
];

/// El listado en CSV (RFC 4180, con `;`), listo para abrir en Excel o en
/// Hojas de cálculo de Google.
///
/// * Empieza con la marca BOM de UTF-8: sin ella, Excel muestra «Ã±» donde
///   va una «ñ».
/// * Las coordenadas van en UNA columna de texto («7.06531, -73.85472»):
///   separadas, Excel en español leería «7.06531» como siete mil
///   seiscientos cincuenta y tres mil y algo.
/// * El texto que escribió la vecina nunca se vuelve fórmula (OWASP · CSV
///   injection): ver [_celda].
String componerListadoCsv(List<Reporte> reportes) {
  final StringBuffer csv = StringBuffer('﻿')
    ..write(columnasDelListado.map(_celda).join(separador))
    ..write('\r\n');

  for (int i = 0; i < reportes.length; i++) {
    final Reporte r = reportes[i];
    final List<String> fila = <String>[
      '${i + 1}',
      _fecha(r.fecha),
      _hora(r.fecha),
      r.categoria?.nombre ?? 'Sin clasificar',
      r.referencia,
      r.tieneUbicacion
          ? '${r.latitud!.toStringAsFixed(5)}, ${r.longitud!.toStringAsFixed(5)}'
          : 'Sin GPS',
      r.precisionMetros == null ? '' : '${r.precisionMetros!.round()}',
      enlaceAlMapa(r)?.toString() ?? '',
      r.fueCompartido ? 'Sí' : 'No',
    ];
    csv
      ..write(fila.map(_celda).join(separador))
      ..write('\r\n');
  }
  return csv.toString();
}

/// «02/11/2026»: día, mes y año, como se escribe en Colombia.
String _fecha(DateTime f) => '${_dos(f.day)}/${_dos(f.month)}/${f.year}';

/// «19:05»: 24 horas, para que la hoja ordene bien.
String _hora(DateTime f) => '${_dos(f.hour)}:${_dos(f.minute)}';

String _dos(int n) => n.toString().padLeft(2, '0');

/// Una celda segura.
///
/// 1. Si empieza con `=`, `+`, `-`, `@`, tabulador o retorno, se le
///    antepone un apóstrofo: así Excel la muestra como texto y no la
///    ejecuta como fórmula. Una referencia como «=HYPERLINK(...)» es solo
///    texto.
/// 2. Si lleva `;`, comillas o saltos de línea, va entre comillas y las
///    comillas internas se duplican (RFC 4180).
String _celda(String valor) {
  String texto = valor;
  if (texto.isNotEmpty && '=+-@\t\r'.contains(texto[0])) {
    texto = "'$texto";
  }
  final bool hayQueCitar = texto.contains(separador) ||
      texto.contains('"') ||
      texto.contains('\n') ||
      texto.contains('\r');
  return hayQueCitar ? '"${texto.replaceAll('"', '""')}"' : texto;
}
