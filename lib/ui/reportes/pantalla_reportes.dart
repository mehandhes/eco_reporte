import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../data/repositorio_simulado.dart';
import '../../domain/reporte.dart';
import '../comun/aviso.dart';
import 'reportes_viewmodel.dart';
import 'selector_escenario.dart';
import 'tarjeta_reporte.dart';

/// HU-04 · «Mis reportes», con los cuatro estados de toda lista.
class PantallaReportes extends StatelessWidget {
  const PantallaReportes({super.key});

  @override
  Widget build(BuildContext context) {
    final ReportesViewModel vm = context.watch<ReportesViewModel>();
    // Nulo fuera de modo desarrollo: entonces no hay selector.
    final RepositorioSimulado? simulado = context.watch<RepositorioSimulado?>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis reportes'),
        actions: <Widget>[
          if (simulado != null) SelectorEscenario(repositorio: simulado),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _crearReporte(context),
        icon: const Icon(Icons.add_a_photo_outlined),
        label: const Text('Reportar'),
      ),
      // El switch sobre un enum obliga a dibujar los cuatro casos: si mañana
      // aparece otro estado, esto deja de compilar hasta decidir qué mostrar.
      body: switch (vm.estado) {
        EstadoUi.cargando => const Center(
            child: CircularProgressIndicator(
              semanticsLabel: 'Cargando tus reportes',
            ),
          ),
        EstadoUi.error => Aviso(
            icono: Icons.error_outline,
            titulo: 'No pudimos leer tus reportes',
            detalle: 'Algo falló al abrirlos en este teléfono. '
                'Vuelve a intentarlo en un momento.',
            accion: 'Reintentar',
            alPulsar: vm.cargar,
          ),
        EstadoUi.vacio => Aviso(
            icono: Icons.eco_outlined,
            titulo: 'Aún no tienes reportes',
            detalle: 'Cuando veas basura acumulada en tu barrio, repórtala '
                'con una foto. Se guarda aunque no tengas datos.',
            accion: 'Crear el primero',
            alPulsar: () => _crearReporte(context),
          ),
        EstadoUi.listo => RefreshIndicator(
            onRefresh: vm.cargar,
            child: ListView.builder(
              // HU-05 · «Volver a la lista»: la posición se guarda con esta
              // llave y se recupera aunque la lista se vuelva a construir
              // (por ejemplo, después de recargar).
              key: const PageStorageKey<String>('mis-reportes'),
              // RC-03: ListView.builder solo construye las filas visibles;
              // con 200 reportes se dibujan unas 8, no 200. Sin itemExtent
              // fijo a propósito: con letra grande la fila crece.
              // 96 abajo para que el botón flotante no tape la última fila.
              padding: const EdgeInsets.only(top: 6, bottom: 96),
              itemCount: vm.reportes.length,
              itemBuilder: (BuildContext context, int i) {
                final Reporte reporte = vm.reportes[i];
                return TarjetaReporte(
                  reporte: reporte,
                  alPulsar: () => context.push('/reporte/${reporte.id}'),
                );
              },
            ),
          ),
      },
    );
  }

  /// HU-01 · Abre el formulario «Nuevo reporte».
  void _crearReporte(BuildContext context) {
    context.push('/nuevo');
  }
}
