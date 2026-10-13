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
          const _FotoGrande(),
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

/// Hueco de la foto en grande. La foto real llega con HU-01 y HU-03.
class _FotoGrande extends StatelessWidget {
  const _FotoGrande();

  @override
  Widget build(BuildContext context) {
    final ColorScheme colores = Theme.of(context).colorScheme;
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        decoration: BoxDecoration(
          color: colores.secondaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.photo_outlined, size: 56, color: colores.onSecondaryContainer),
            const SizedBox(height: 8),
            Text(
              'Sin foto en los datos de prueba',
              style: TextStyle(color: colores.onSecondaryContainer),
            ),
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
