import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../data/reporte_repository.dart';
import '../data/repositorio_simulado.dart';
import '../ui/reportes/reportes_viewmodel.dart';
import 'enrutador.dart';
import 'tema.dart';

/// Raíz de la app: inyecta las dependencias y monta el enrutador.
class EcoReporteApp extends StatefulWidget {
  const EcoReporteApp({super.key, required this.repositorio, this.simulado});

  /// De dónde salen los reportes.
  final ReporteRepository repositorio;

  /// El mismo repositorio, si es simulado y se está en desarrollo: habilita
  /// el selector de escenario. Nulo en cualquier otro caso.
  final RepositorioSimulado? simulado;

  @override
  State<EcoReporteApp> createState() => _EcoReporteAppState();
}

class _EcoReporteAppState extends State<EcoReporteApp> {
  late final GoRouter _enrutador = crearEnrutador();

  @override
  void dispose() {
    _enrutador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ReporteRepository>.value(value: widget.repositorio),
        Provider<RepositorioSimulado?>.value(value: widget.simulado),
        // '..cargar()' dispara la primera carga en cuanto se crea el ViewModel.
        ChangeNotifierProvider<ReportesViewModel>(
          create: (_) => ReportesViewModel(widget.repositorio)..cargar(),
        ),
      ],
      child: MaterialApp.router(
        title: 'EcoReporte',
        debugShowCheckedModeBanner: false,
        theme: temaClaro(),
        darkTheme: temaOscuro(),
        routerConfig: _enrutador,
      ),
    );
  }
}
