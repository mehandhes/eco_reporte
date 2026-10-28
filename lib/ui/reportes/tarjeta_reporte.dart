import 'dart:io';

import 'package:material_ui/material_ui.dart';

import '../../domain/reporte.dart';
import '../comun/formatos.dart';

/// Una fila de «Mis reportes»: miniatura, lugar y fecha (HU-04), y el tipo
/// de residuo si lo tiene (HU-06).
class TarjetaReporte extends StatelessWidget {
  const TarjetaReporte({super.key, required this.reporte, required this.alPulsar});

  final Reporte reporte;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext context) {
    final String fecha = formatearFechaYHora(reporte.fecha);
    // HU-06 · el tipo de residuo se lee en la lista sin abrir el detalle.
    final String cuando = reporte.categoria == null
        ? fecha
        : '${reporte.categoria!.nombre} · $fecha';
    final String titulo = reporte.referencia.isNotEmpty
        ? reporte.referencia
        : formatearCoordenadas(reporte);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        minVerticalPadding: 12,
        leading: _Miniatura(rutaFoto: reporte.rutaFoto),
        title: Text(
          titulo,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        // Hallazgo H1 · la lista muestra qué reportes ya se compartieron.
        subtitle: reporte.fueCompartido
            ? Text.rich(
                TextSpan(
                  text: '$cuando · ',
                  children: <InlineSpan>[
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(
                        Icons.mark_chat_read_outlined,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const TextSpan(text: ' Compartido'),
                  ],
                ),
              )
            : Text(cuando),
        trailing: const Icon(Icons.chevron_right),
        onTap: alPulsar,
      ),
    );
  }
}

/// Miniatura de la foto (HU-03 · el reporte sigue «con su foto»). Los datos
/// simulados no traen foto: entonces se dibuja un hueco.
class _Miniatura extends StatelessWidget {
  const _Miniatura({required this.rutaFoto});

  final String? rutaFoto;

  static const double _lado = 48;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colores = Theme.of(context).colorScheme;
    final Widget hueco = Container(
      width: _lado,
      height: _lado,
      color: colores.secondaryContainer,
      child: Icon(Icons.photo_outlined, color: colores.onSecondaryContainer),
    );
    return Semantics(
      label: rutaFoto == null ? 'Sin foto' : 'Foto del punto',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: rutaFoto == null
            ? hueco
            : Image.file(
                File(rutaFoto!),
                width: _lado,
                height: _lado,
                fit: BoxFit.cover,
                // Decodificar a 48 dp y no a 1600 px: con cientos de filas,
                // esto es lo que mantiene la lista fluida (RC-03).
                cacheWidth: (_lado * MediaQuery.devicePixelRatioOf(context)).round(),
                errorBuilder: (_, _, _) => hueco,
              ),
      ),
    );
  }
}
