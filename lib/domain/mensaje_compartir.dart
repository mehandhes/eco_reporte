import 'reporte.dart';

/// HU-10 · El texto que viaja por WhatsApp junto a la foto.
///
/// Es una función pura, sin Flutter ni plugins: se prueba sola y cualquier
/// cambio de redacción se ve en `test/mensaje_compartir_test.dart`.
String componerMensaje(
  Reporte reporte, {
  required String Function(DateTime) formatearFecha,
}) {
  final StringBuffer texto = StringBuffer()
    ..writeln('Punto crítico de basura reportado con EcoReporte')
    ..writeln('Fecha: ${formatearFecha(reporte.fecha)}');

  // HU-06 · quien lo recibe sabe qué hay antes de ir.
  if (reporte.categoria != null) {
    texto.writeln('Tipo: ${reporte.categoria!.nombre}');
  }

  if (reporte.referencia.isNotEmpty) {
    texto.writeln('Lugar: ${reporte.referencia}');
  }

  final Uri? mapa = enlaceAlMapa(reporte);
  if (mapa == null) {
    texto.writeln('Ubicación: sin GPS, guíate por la referencia del lugar.');
  } else {
    final String aviso = reporte.ubicacionAproximada
        ? ' (aproximada, ± ${reporte.precisionMetros!.round()} m)'
        : '';
    texto.writeln('Mapa$aviso: $mapa');
  }
  return texto.toString().trimRight();
}

/// Enlace universal de Google Maps («Maps URLs»): se abre en la app de
/// mapas o en el navegador, en Android y en iPhone, sin clave de API.
/// Nulo si el reporte no tiene coordenadas.
Uri? enlaceAlMapa(Reporte reporte) {
  if (!reporte.tieneUbicacion) return null;
  final String punto = '${reporte.latitud!.toStringAsFixed(5)},'
      '${reporte.longitud!.toStringAsFixed(5)}';
  return Uri.https('www.google.com', '/maps/search/', <String, String>{
    'api': '1',
    'query': punto,
  });
}
