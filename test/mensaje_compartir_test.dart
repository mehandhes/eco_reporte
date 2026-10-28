import 'package:eco_reporte/domain/mensaje_compartir.dart';
import 'package:eco_reporte/domain/reporte.dart';
import 'package:eco_reporte/ui/comun/formatos.dart';
import 'package:flutter_test/flutter_test.dart';

/// HU-10 · «el mensaje lleva la foto, la fecha, la referencia del lugar y un
/// enlace al mapa con la ubicación». La foto la adjunta el servicio; aquí
/// se comprueba el texto.
void main() {
  final Reporte conGps = Reporte(
    id: 1,
    fecha: DateTime(2026, 11, 2, 7, 30),
    referencia: 'Frente a la cancha, junto al poste',
    latitud: 7.065312,
    longitud: -73.854718,
    precisionMetros: 8,
    rutaFoto: '/app/fotos/1.jpg',
  );

  String mensaje(Reporte r) =>
      componerMensaje(r, formatearFecha: formatearFechaYHora);

  test('lleva fecha, referencia y enlace al mapa', () {
    final String texto = mensaje(conGps);

    expect(texto, contains('Fecha: 2 nov 2026 · 7:30 a. m.'));
    expect(texto, contains('Lugar: Frente a la cancha, junto al poste'));
    expect(
      texto,
      contains('https://www.google.com/maps/search/?api=1&query=7.06531%2C-73.85472'),
    );
  });

  test('sin GPS, el mensaje dice que se guíen por la referencia', () {
    final Reporte sinGps = Reporte(
      id: 2,
      fecha: DateTime(2026, 11, 2),
      referencia: 'Esquina del colegio',
    );

    expect(mensaje(sinGps), contains('sin GPS, guíate por la referencia'));
    expect(enlaceAlMapa(sinGps), isNull);
  });

  test('una ubicación aproximada se avisa también en el mensaje', () {
    final Reporte aproximado = Reporte(
      id: 3,
      fecha: DateTime(2026, 11, 2),
      referencia: '',
      latitud: 7.06244,
      longitud: -73.85155,
      precisionMetros: 64.4,
    );

    final String texto = mensaje(aproximado);

    expect(texto, contains('Mapa (aproximada, ± 64 m):'));
    expect(texto, isNot(contains('Lugar:')), reason: 'sin referencia, no hay línea vacía');
  });

  test('HU-06: el tipo de residuo va en el mensaje, si se eligió', () {
    final Reporte conTipo = Reporte(
      id: 4,
      fecha: DateTime(2026, 11, 2),
      referencia: 'Lote de la 52',
      categoria: Categoria.escombros,
    );

    expect(mensaje(conTipo), contains('Tipo: Escombros'));
    expect(mensaje(conGps), isNot(contains('Tipo:')));
  });
}
