import 'package:material_ui/material_ui.dart';

import '../../domain/reporte.dart';
import '../comun/formatos.dart';

/// Una fila de «Mis reportes»: miniatura, lugar y fecha (HU-04).
class TarjetaReporte extends StatelessWidget {
  const TarjetaReporte({super.key, required this.reporte, required this.alPulsar});

  final Reporte reporte;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext context) {
    final String cuando =
        '${formatearFecha(reporte.fecha)} · ${formatearHora(reporte.fecha)}';
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        minVerticalPadding: 12,
        leading: const _Miniatura(),
        title: Text(
          reporte.referencia,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(cuando),
        trailing: const Icon(Icons.chevron_right),
        onTap: alPulsar,
      ),
    );
  }
}

/// Hueco de la foto. La miniatura real llega con HU-01 (cámara) y HU-03
/// (guardado); en los datos simulados no hay archivo que mostrar.
class _Miniatura extends StatelessWidget {
  const _Miniatura();

  @override
  Widget build(BuildContext context) {
    final ColorScheme colores = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Sin foto',
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: colores.secondaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.photo_outlined, color: colores.onSecondaryContainer),
      ),
    );
  }
}
