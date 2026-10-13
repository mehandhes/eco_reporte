import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:material_ui/material_ui.dart';

import 'app/eco_reporte_app.dart';
import 'data/repositorio_simulado.dart';

void main() {
  // Sprint 1 · INV-04: datos simulados. TEC-02 (Sprint 2) lo cambia por el
  // repositorio SQLite sin tocar ninguna pantalla.
  final RepositorioSimulado repositorio = RepositorioSimulado();
  runApp(
    EcoReporteApp(
      repositorio: repositorio,
      // El selector de escenario solo existe en modo de desarrollo.
      simulado: kDebugMode ? repositorio : null,
    ),
  );
}
