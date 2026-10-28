import 'dart:io';

import 'package:material_ui/material_ui.dart';

import '../../domain/reporte.dart';
import '../comun/formatos.dart';
import '../comun/icono_categoria.dart';

/// Una fila de «Mis reportes»: miniatura, lugar, tipo de residuo si lo
/// tiene (HU-06) y fecha (HU-04).
class TarjetaReporte extends StatelessWidget {
  const TarjetaReporte({super.key, required this.reporte, required this.alPulsar});

  final Reporte reporte;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext context) {
    final String cuando = formatearFechaYHora(reporte.fecha);
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
        // Sprint 6 · una línea por dato: el tipo con su icono (HU-06), la
        // fecha y la marca «Compartido» (hallazgo H1). Así la fecha no se
        // parte en dos renglones.
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (reporte.categoria != null)
              _Linea(
                icono: iconoDe(reporte.categoria!),
                texto: reporte.categoria!.nombre,
              ),
            Text(cuando),
            if (reporte.fueCompartido)
              const _Linea(icono: Icons.mark_chat_read_outlined, texto: 'Compartido'),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: alPulsar,
      ),
    );
  }
}

/// Un dato del subtítulo con su icono, en su propia línea.
class _Linea extends StatelessWidget {
  const _Linea({required this.icono, required this.texto});

  final IconData icono;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: <Widget>[
          Icon(icono, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 6),
          Flexible(child: Text(texto)),
        ],
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
