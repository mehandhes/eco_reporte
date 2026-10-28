import '../../domain/reporte.dart';

const List<String> _meses = <String>[
  'ene', 'feb', 'mar', 'abr', 'may', 'jun',
  'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
];

const List<String> _mesesLargos = <String>[
  'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
  'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
];

/// «octubre de 2026».
String formatearMes(DateTime mes) =>
    '${_mesesLargos[mes.month - 1]} de ${mes.year}';

/// «13 oct 2026».
String formatearFecha(DateTime fecha) =>
    '${fecha.day} ${_meses[fecha.month - 1]} ${fecha.year}';

/// «7:05 p. m.».
String formatearHora(DateTime fecha) {
  final int hora = fecha.hour % 12 == 0 ? 12 : fecha.hour % 12;
  final String minutos = fecha.minute.toString().padLeft(2, '0');
  final String sufijo = fecha.hour < 12 ? 'a. m.' : 'p. m.';
  return '$hora:$minutos $sufijo';
}

/// «13 oct 2026 · 7:05 p. m.».
String formatearFechaYHora(DateTime fecha) =>
    '${formatearFecha(fecha)} · ${formatearHora(fecha)}';

/// «7.06531, -73.85472»: cinco decimales, unos 1,1 m.
String formatearPunto(double latitud, double longitud) =>
    '${latitud.toStringAsFixed(5)}, ${longitud.toStringAsFixed(5)}';

/// «± 12 m».
String formatearMetros(double metros) => '± ${metros.round()} m';

/// Coordenadas del reporte o el motivo de que no haya.
String formatearCoordenadas(Reporte reporte) {
  if (!reporte.tieneUbicacion) return 'Sin ubicación: no se tomó el GPS';
  return formatearPunto(reporte.latitud!, reporte.longitud!);
}

/// «± 12 m», o nada si no hay precisión.
String formatearPrecision(Reporte reporte) {
  final double? metros = reporte.precisionMetros;
  return metros == null ? '' : formatearMetros(metros);
}
