import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../domain/reporte.dart';
import '../comun/aviso.dart';
import '../comun/formatos.dart';
import '../reportes/reportes_viewmodel.dart';

/// HU-05 · Detalle de un reporte: foto en grande, fecha y hora, y lugar.
class PantallaDetalle extends StatelessWidget {
  const PantallaDetalle({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    final Reporte? reporte = context.watch<ReportesViewModel>().buscar(id);

    return Scaffold(
      appBar: AppBar(title: const Text('Reporte')),
      body: reporte == null
          ? const Aviso(
              icono: Icons.search_off,
              titulo: 'Este reporte ya no está',
              detalle: 'Vuelve a «Mis reportes» para ver los que tienes.',
            )
          : _Contenido(reporte: reporte),
    );
  }
}

class _Contenido extends StatelessWidget {
  const _Contenido({required this.reporte});

  final Reporte reporte;

  @override
  Widget build(BuildContext context) {
    final String precision = formatearPrecision(reporte);
    final String coordenadas = precision.isEmpty
        ? formatearCoordenadas(reporte)
        : '${formatearCoordenadas(reporte)}  ($precision)';

    // SingleChildScrollView + textos que se parten: en 360 dp todo se lee
    // sin cortarse y sin desplazamiento lateral (escenario «Pantalla pequeña»).
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _FotoGrande(rutaFoto: reporte.rutaFoto),
          const SizedBox(height: 16),
          _Dato(icono: Icons.place_outlined, etiqueta: 'Lugar', valor: reporte.referencia),
          _Dato(
            icono: Icons.my_location,
            etiqueta: 'Coordenadas',
            valor: coordenadas,
          ),
          if (reporte.ubicacionAproximada)
            const _Dato(
              icono: Icons.warning_amber_outlined,
              etiqueta: 'Ubicación aproximada',
              valor: 'El GPS dio una precisión peor que 50 m. '
                  'La referencia del lugar ayuda a encontrarlo.',
            ),
          _Dato(
            icono: Icons.event_outlined,
            etiqueta: 'Fecha y hora',
            valor: '${formatearFecha(reporte.fecha)} · '
                '${formatearHora(reporte.fecha)}',
          ),
        ],
      ),
    );
  }
}

/// La foto en grande (HU-05). Si el archivo ya no está, se dice en lugar
/// de romper la pantalla.
class _FotoGrande extends StatelessWidget {
  const _FotoGrande({required this.rutaFoto});

  final String? rutaFoto;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: rutaFoto == null
            ? const _SinFoto(texto: 'Sin foto en los datos de prueba')
            : Semantics(
                image: true,
                label: 'Foto del punto crítico',
                child: Image.file(
                  File(rutaFoto!),
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      const _SinFoto(texto: 'La foto ya no está en el teléfono'),
                ),
              ),
      ),
    );
  }
}

class _SinFoto extends StatelessWidget {
  const _SinFoto({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colores = Theme.of(context).colorScheme;
    return ColoredBox(
      color: colores.secondaryContainer,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.photo_outlined, size: 56, color: colores.onSecondaryContainer),
            const SizedBox(height: 8),
            Text(texto, style: TextStyle(color: colores.onSecondaryContainer)),
          ],
        ),
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  const _Dato({required this.icono, required this.etiqueta, required this.valor});

  final IconData icono;
  final String etiqueta;
  final String valor;

  @override
  Widget build(BuildContext context) {
    final TextTheme textos = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icono),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(etiqueta, style: textos.labelLarge),
                const SizedBox(height: 2),
                Text(valor, style: textos.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
