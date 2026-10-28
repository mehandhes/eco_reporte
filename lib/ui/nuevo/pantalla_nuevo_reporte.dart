import 'package:flutter/services.dart' show HapticFeedback;
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
import 'campo_categoria.dart';
import 'campo_referencia.dart';
import 'nuevo_reporte_viewmodel.dart';

/// Formulario «Nuevo reporte».
/// Sprint 2: HU-01 (foto), HU-12 (referencia) y HU-03 (guardar).
/// Sprint 3: HU-02 (ubicación automática).
/// Sprint 5: HU-06 (tipo de residuo).
/// Sprint 6: partes con título y la barra de «Guardar» fija abajo.
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
      // Sprint 6 · «Guardar» vive abajo, siempre a la vista y al alcance
      // del pulgar, y dice qué falta antes de tocarlo.
      bottomNavigationBar: _BarraGuardar(
        vm: vm,
        alGuardar: () => _guardar(context, vm),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: <Widget>[
          const _Titulo('Foto del punto'),
          BloqueFoto(vm: vm),
          const SizedBox(height: 24),
          const _Titulo('Dónde está'),
          BloqueUbicacion(vm: vm),
          const SizedBox(height: 16),
          CampoReferencia(vm: vm),
          const SizedBox(height: 16),
          CampoCategoria(vm: vm),
          if (vm.errorGuardado != null) ...<Widget>[
            const SizedBox(height: 16),
            _MensajeError(texto: vm.errorGuardado!),
          ],
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

    // Sprint 6 · una vibración corta confirma el guardado aunque el sol no
    // deje leer la pantalla.
    HapticFeedback.mediumImpact();
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

/// Título de una parte del formulario. TalkBack lo anuncia como
/// encabezado: se puede saltar de parte en parte.
class _Titulo extends StatelessWidget {
  const _Titulo(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Semantics(
        header: true,
        child: Text(texto, style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }
}

/// Sprint 6 · La barra de abajo: qué falta (o que ya está listo) y el botón.
///
/// El botón no se apaga cuando falta algo: al tocarlo, el formulario señala
/// lo que falta junto al campo (HU-03 · «Falta la foto»). Solo se apaga
/// mientras guarda, y así un doble toque no crea dos reportes.
class _BarraGuardar extends StatelessWidget {
  const _BarraGuardar({required this.vm, required this.alGuardar});

  final NuevoReporteViewModel vm;
  final VoidCallback alGuardar;

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = Theme.of(context);
    final ColorScheme colores = tema.colorScheme;
    final bool listo = vm.listoParaGuardar;
    return Material(
      color: colores.surfaceContainer,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Semantics(
                liveRegion: true,
                child: Row(
                  children: <Widget>[
                    // Icono y texto, nunca solo el color (RC-02).
                    Icon(
                      listo ? Icons.check_circle : Icons.info_outline,
                      size: 20,
                      color: listo ? colores.primary : colores.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(vm.estadoGuardar, style: tema.textTheme.bodyMedium),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              FilledButton.icon(
                onPressed: vm.guardando ? null : alGuardar,
                icon: vm.guardando
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(vm.guardando ? 'Guardando…' : 'Guardar reporte'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
