import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../privacidad/privacidad_viewmodel.dart';

/// HU-01 · Abre el formulario «Nuevo reporte». La primera vez pasa antes
/// por el aviso de privacidad (TEC-05, RC-06). Se usa desde la pantalla de
/// inicio y desde «Mis reportes».
Future<void> crearReporte(BuildContext context) async {
  if (!context.read<PrivacidadViewModel>().aceptado) {
    final bool? sigue = await context.push<bool>('/privacidad?primera=1');
    if (sigue != true || !context.mounted) return;
  }
  context.push('/nuevo');
}
