import '../../domain/reporte.dart';

const List<String> _meses = <String>[
  'ene', 'feb', 'mar', 'abr', 'may', 'jun',
  'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
];

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

/// Coordenadas con cinco decimales (unos 1,1 m) o el motivo de que no haya.
String formatearCoordenadas(Reporte reporte) {
  if (!reporte.tieneUbicacion) return 'Sin ubicación: se negó el permiso';
  final String lat = reporte.latitud!.toStringAsFixed(5);
  final String lng = reporte.longitud!.toStringAsFixed(5);
  return '$lat, $lng';
}

/// «± 12 m», o nada si no hay precisión.
String formatearPrecision(Reporte reporte) {
  final double? metros = reporte.precisionMetros;
  if (metros == null) return '';
  return '± ${metros.round()} m';
}
