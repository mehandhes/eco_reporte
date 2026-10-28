import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../data/fotos/almacen_fotos.dart';
import '../../data/fotos/fuente_fotos.dart';
import '../../data/reporte_repository.dart';
import '../../data/ubicacion/fuente_ubicacion.dart';
import '../../domain/reporte.dart';
import '../reportes/reportes_viewmodel.dart';
import 'bloque_foto.dart';
import 'bloque_ubicacion.dart';
import 'campo_referencia.dart';
import 'nuevo_reporte_viewmodel.dart';

/// Formulario «Nuevo reporte».
/// Sprint 2: HU-01 (foto), HU-12 (referencia) y HU-03 (guardar).
/// Sprint 3: HU-02 (ubicación automática).
class PantallaNuevoReporte extends StatelessWidget {
  const PantallaNuevoReporte({super.key});

  @override
  Widget build(BuildContext context) {
    // Este ViewModel vive solo mientras la pantalla esté abierta.
    return ChangeNotifierProvider<NuevoReporteViewModel>(
      create: (BuildContext context) => NuevoReporteViewModel(
        fotos: context.read<FuenteFotos>(),
        almacen: context.read<AlmacenFotos>(),
        repositorio: context.read<ReporteRepository>(),
        ubicacion: context.read<FuenteUbicacion>(),
      )
        ..recuperarFotoPerdida()
        // HU-02 · «La ubicación se toma sola al abrir el formulario».
        ..buscarUbicacion(),
      child: const _Formulario(),
    );
  }
}

class _Formulario extends StatelessWidget {
  const _Formulario();

  @override
  Widget build(BuildContext context) {
    final NuevoReporteViewModel vm = context.watch<NuevoReporteViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo reporte')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: <Widget>[
          BloqueFoto(vm: vm),
          const SizedBox(height: 16),
          BloqueUbicacion(vm: vm),
          const SizedBox(height: 24),
          CampoReferencia(vm: vm),
          if (vm.errorGuardado != null) ...<Widget>[
            const SizedBox(height: 16),
            _MensajeError(texto: vm.errorGuardado!),
          ],
          const SizedBox(height: 24),
          FilledButton.icon(
            // No se apaga cuando falta algo: al tocarlo, el formulario dice
            // qué falta (HU-03 · «Falta la foto»). Solo se apaga mientras
            // guarda, y así un doble toque no crea dos reportes.
            onPressed: vm.guardando ? null : () => _guardar(context, vm),
            icon: vm.guardando
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save_outlined),
            label: Text(vm.guardando ? 'Guardando…' : 'Guardar reporte'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Se guarda en tu teléfono, aunque no tengas datos.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Future<void> _guardar(BuildContext context, NuevoReporteViewModel vm) async {
    // Se toman ANTES del await: después, este widget puede haberse
    // desmontado (regla use_build_context_synchronously).
    final GoRouter navegador = GoRouter.of(context);
    final ScaffoldMessengerState mensajero = ScaffoldMessenger.of(context);
    final ReportesViewModel lista = context.read<ReportesViewModel>();

    final Reporte? guardado = await vm.guardar();
    if (guardado == null) return;

    lista.agregar(guardado);
    mensajero
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          // HU-03 · «La confirmación dice qué sigue».
          content: Text(
            'Reporte guardado. Puedes compartirlo con tu JAC '
            'desde «Mis reportes».',
          ),
        ),
      );
    navegador.pop();
  }
}

class _MensajeError extends StatelessWidget {
  const _MensajeError({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colores = Theme.of(context).colorScheme;
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colores.errorContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.error_outline, color: colores.onErrorContainer),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                texto,
                style: TextStyle(color: colores.onErrorContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
