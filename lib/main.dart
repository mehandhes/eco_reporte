import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:material_ui/material_ui.dart';

import 'app/eco_reporte_app.dart';
import 'data/reporte_repository.dart';
import 'data/repositorio_simulado.dart';
import 'data/repositorio_sqlite.dart';

/// `flutter run --dart-define=DATOS=simulados` arranca con los datos de
/// ejemplo del Sprint 1 y el selector de escenario (solo en desarrollo).
const String _datos = String.fromEnvironment('DATOS');

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Sprint 2 · TEC-02: la app guarda en SQLite. Ninguna pantalla cambió:
  // solo cambia qué implementación de ReporteRepository se inyecta aquí.
  final bool simulados = kDebugMode && _datos == 'simulados';
  final RepositorioSimulado? simulado = simulados ? RepositorioSimulado() : null;
  final ReporteRepository repositorio = simulado ?? RepositorioSqlite();

  runApp(EcoReporteApp(repositorio: repositorio, simulado: simulado));
}
