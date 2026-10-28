import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../data/fotos/fuente_fotos.dart';
import 'bloque_foto.dart';
import 'nuevo_reporte_viewmodel.dart';

/// Formulario «Nuevo reporte». Sprint 2: HU-01 (foto).
class PantallaNuevoReporte extends StatelessWidget {
  const PantallaNuevoReporte({super.key});

  @override
  Widget build(BuildContext context) {
    // Este ViewModel vive solo mientras la pantalla esté abierta.
    return ChangeNotifierProvider<NuevoReporteViewModel>(
      create: (BuildContext context) => NuevoReporteViewModel(
        fotos: context.read<FuenteFotos>(),
      )..recuperarFotoPerdida(),
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
        ],
      ),
    );
  }
}
