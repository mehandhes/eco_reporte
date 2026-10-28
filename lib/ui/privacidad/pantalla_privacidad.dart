import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'privacidad_viewmodel.dart';

/// TEC-05 · Aviso de privacidad (Ley 1581 de 2012 y su decreto
/// reglamentario 1377 de 2013, art. 15: responsable, tratamiento y
/// finalidad, derechos, y cómo conocer la política).
///
/// Se muestra antes del primer reporte ([antesDelPrimerReporte]) y siempre
/// que se quiera desde el icono de información de «Mis reportes».
class PantallaPrivacidad extends StatelessWidget {
  const PantallaPrivacidad({super.key, this.antesDelPrimerReporte = false});

  final bool antesDelPrimerReporte;

  /// Quién responde por los datos. Cada equipo pone aquí su nombre y un
  /// contacto real antes de repartir el APK.
  static const String responsable =
      'Equipo EcoReporte · curso Desarrollo de Aplicaciones Móviles, '
      'UNIPAZ, Barrancabermeja. Contacto: a través del docente del curso.';

  @override
  Widget build(BuildContext context) {
    final TextTheme textos = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(antesDelPrimerReporte ? 'Antes de tu primer reporte' : 'Privacidad'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: <Widget>[
          Text('Tus reportes se quedan en tu teléfono', style: textos.titleLarge),
          const SizedBox(height: 12),
          const _Punto(
            icono: Icons.photo_camera_outlined,
            texto: 'Guardamos la foto, la referencia del lugar, la fecha y, si '
                'lo permites, la ubicación. Sirven para una sola cosa: armar el '
                'reporte del punto de basura.',
          ),
          const _Punto(
            icono: Icons.my_location,
            texto: 'La ubicación se lee una vez, mientras llenas el reporte. '
                'Nunca en segundo plano.',
          ),
          const _Punto(
            icono: Icons.phone_android,
            texto: 'Nada se envía a un servidor. El reporte sale de tu teléfono '
                'solo cuando tú lo compartes, por la app que elijas.',
          ),
          const _Punto(
            icono: Icons.no_photography_outlined,
            texto: 'Fotografía el lugar, no a las personas ni las placas de los '
                'carros.',
          ),
          const _Punto(
            icono: Icons.delete_outline,
            texto: 'Puedes borrar cualquier reporte, con su foto, desde su '
                'detalle.',
          ),
          const SizedBox(height: 16),
          Text('Tus derechos', style: textos.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Según la Ley 1581 de 2012 puedes conocer, actualizar, rectificar y '
            'suprimir tus datos, revocar tu autorización y presentar quejas ante '
            'la Superintendencia de Industria y Comercio.',
            style: textos.bodyMedium,
          ),
          const SizedBox(height: 16),
          Text('Responsable', style: textos.titleMedium),
          const SizedBox(height: 8),
          Text(responsable, style: textos.bodyMedium),
          const SizedBox(height: 8),
          Text(
            'La política completa de tratamiento de datos está en el repositorio '
            'del proyecto (docs/privacidad.md) y se entrega a quien la pida.',
            style: textos.bodySmall,
          ),
          if (antesDelPrimerReporte) ...<Widget>[
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () async {
                final GoRouter navegador = GoRouter.of(context);
                await context.read<PrivacidadViewModel>().aceptar();
                navegador.pop(true);
              },
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
              child: const Text('Entendido, crear mi reporte'),
            ),
          ],
        ],
      ),
    );
  }
}

class _Punto extends StatelessWidget {
  const _Punto({required this.icono, required this.texto});

  final IconData icono;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icono, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(texto, style: Theme.of(context).textTheme.bodyLarge)),
        ],
      ),
    );
  }
}
