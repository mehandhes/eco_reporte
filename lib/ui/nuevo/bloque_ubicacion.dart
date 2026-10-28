import 'package:material_ui/material_ui.dart';

import '../comun/formatos.dart';
import 'nuevo_reporte_viewmodel.dart';

/// HU-02 · La ubicación dentro del formulario. Cada estado dice qué pasa y,
/// si hay algo que hacer, ofrece el botón para hacerlo (heurísticas H1 y H9).
class BloqueUbicacion extends StatelessWidget {
  const BloqueUbicacion({super.key, required this.vm});

  final NuevoReporteViewModel vm;

  static const String _paraQue =
      'La app usa tu ubicación una sola vez, mientras llenas este reporte, '
      'para marcar dónde está el punto. Sin ella también puedes reportar: '
      'escribe una referencia del lugar.';

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: switch (vm.estadoUbicacion) {
        EstadoUbicacion.buscando => const _Fila(
            icono: SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
            titulo: 'Buscando tu ubicación…',
            detalle: 'Mientras tanto puedes tomar la foto.',
          ),
        EstadoUbicacion.obtenida => _Obtenida(vm: vm),
        EstadoUbicacion.sinPermiso => _Fila(
            icono: const Icon(Icons.location_off_outlined),
            titulo: 'Sin permiso de ubicación',
            detalle: _paraQue,
            accion: 'Permitir ubicación',
            alPulsar: vm.buscarUbicacion,
          ),
        EstadoUbicacion.bloqueada => _Fila(
            icono: const Icon(Icons.location_off_outlined),
            titulo: 'La ubicación está bloqueada para EcoReporte',
            detalle: '$_paraQue Para activarla: Ajustes › Aplicaciones › '
                'EcoReporte › Permisos › Ubicación.',
            accion: 'Abrir ajustes',
            alPulsar: vm.abrirAjustesDeLaApp,
            accion2: 'Ya la activé',
            alPulsar2: vm.buscarUbicacion,
          ),
        EstadoUbicacion.gpsApagado => _Fila(
            icono: const Icon(Icons.gps_off),
            titulo: 'El GPS está apagado',
            detalle: 'Actívalo para marcar el punto, o escribe una '
                'referencia del lugar.',
            accion: 'Activar GPS',
            alPulsar: vm.abrirAjustesDeUbicacion,
            accion2: 'Ya lo activé',
            alPulsar2: vm.buscarUbicacion,
          ),
        EstadoUbicacion.sinSenal => _Fila(
            icono: const Icon(Icons.gps_not_fixed),
            titulo: 'No llegó la señal del GPS',
            detalle: 'Prueba en un lugar despejado, o escribe una referencia '
                'del lugar.',
            accion: 'Intentar de nuevo',
            alPulsar: vm.buscarUbicacion,
          ),
      },
    );
  }
}

class _Obtenida extends StatelessWidget {
  const _Obtenida({required this.vm});

  final NuevoReporteViewModel vm;

  @override
  Widget build(BuildContext context) {
    final String texto = '${formatearPunto(vm.latitud!, vm.longitud!)}  '
        '(${formatearMetros(vm.precisionMetros ?? 0)})';

    if (!vm.ubicacionAproximada) {
      return _Fila(
        icono: Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary),
        titulo: 'Ubicación lista',
        detalle: texto,
      );
    }
    return _Fila(
      aviso: true,
      icono: const Icon(Icons.warning_amber_outlined),
      titulo: 'Ubicación aproximada',
      detalle: '$texto. Una referencia del lugar ayuda a encontrarlo.',
      accion: 'Pedir de nuevo',
      alPulsar: vm.buscarUbicacion,
    );
  }
}

class _Fila extends StatelessWidget {
  const _Fila({
    required this.icono,
    required this.titulo,
    required this.detalle,
    this.accion,
    this.alPulsar,
    this.accion2,
    this.alPulsar2,
    this.aviso = false,
  });

  /// Sprint 6 · Pide atención sin ser un error (ubicación aproximada): se
  /// pinta con el «amarillo señal» del tema. Siempre con icono y palabras,
  /// nunca solo con el color.
  final bool aviso;
  final Widget icono;
  final String titulo;
  final String detalle;
  final String? accion;
  final VoidCallback? alPulsar;
  final String? accion2;
  final VoidCallback? alPulsar2;

  @override
  Widget build(BuildContext context) {
    final TextTheme textos = Theme.of(context).textTheme;
    final ColorScheme colores = Theme.of(context).colorScheme;
    return Card.outlined(
      margin: EdgeInsets.zero,
      color: aviso ? colores.tertiaryContainer : null,
      shape: aviso
          ? RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(14)),
              side: BorderSide(color: colores.tertiary),
            )
          : null,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: IconTheme.merge(
                    data: IconThemeData(
                      color: aviso ? colores.onTertiaryContainer : null,
                    ),
                    child: icono,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        titulo,
                        style: textos.titleSmall?.copyWith(
                          color: aviso ? colores.onTertiaryContainer : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        detalle,
                        style: textos.bodyMedium?.copyWith(
                          color: aviso ? colores.onTertiaryContainer : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (accion != null || accion2 != null)
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Wrap(
                spacing: 8,
                children: <Widget>[
                  if (accion2 != null)
                    TextButton(
                      onPressed: alPulsar2,
                      style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
                      child: Text(accion2!),
                    ),
                  if (accion != null)
                    TextButton(
                      onPressed: alPulsar,
                      style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
                      child: Text(accion!),
                    ),
                ],
                ),
              )
            else
              const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
