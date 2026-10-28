import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../data/compartir/servicio_compartir.dart';
import '../data/compartir/servicio_exportar.dart';
import '../data/fotos/almacen_fotos.dart';
import '../data/fotos/fuente_fotos.dart';
import '../data/fotos/fuente_fotos_image_picker.dart';
import '../data/preferencias/preferencias_app.dart';
import '../data/reporte_repository.dart';
import '../data/repositorio_simulado.dart';
import '../data/ubicacion/fuente_ubicacion.dart';
import '../data/ubicacion/fuente_ubicacion_geolocator.dart';
import '../ui/privacidad/privacidad_viewmodel.dart';
import '../ui/reportes/reportes_viewmodel.dart';
import 'enrutador.dart';
import 'tema.dart';

/// Raíz de la app: inyecta las dependencias y monta el enrutador.
class EcoReporteApp extends StatefulWidget {
  const EcoReporteApp({
    super.key,
    required this.repositorio,
    this.simulado,
    this.fotos,
    this.almacen,
    this.ubicacion,
    this.compartir,
    this.exportar,
    this.preferencias,
    this.rutaInicial = '/',
  });

  /// De dónde salen los reportes.
  final ReporteRepository repositorio;

  /// El mismo repositorio, si es simulado y se está en desarrollo: habilita
  /// el selector de escenario. Nulo en cualquier otro caso.
  final RepositorioSimulado? simulado;

  /// Cámara y galería (HU-01). Nulo: la real, con image_picker. Las pruebas
  /// pasan una falsa.
  final FuenteFotos? fotos;

  /// Carpeta de las fotos guardadas (HU-03). Nulo: la carpeta de la app.
  final AlmacenFotos? almacen;

  /// GPS (HU-02). Nulo: el real, con geolocator.
  final FuenteUbicacion? ubicacion;

  /// Menú de compartir (HU-10). Nulo: el del sistema, con share_plus.
  final ServicioCompartir? compartir;

  /// Listado del mes (HU-09). Nulo: archivo temporal + share_plus.
  final ServicioExportar? exportar;

  /// Dónde arranca la app. '/' (inicio) en el teléfono; las pruebas de
  /// «Mis reportes» arrancan en '/reportes'.
  final String rutaInicial;

  /// Si ya se vio el aviso de privacidad (TEC-05). Nulo: shared_preferences.
  final PreferenciasApp? preferencias;

  @override
  State<EcoReporteApp> createState() => _EcoReporteAppState();
}

class _EcoReporteAppState extends State<EcoReporteApp> {
  late final GoRouter _enrutador = crearEnrutador(inicial: widget.rutaInicial);
  late final FuenteFotos _fotos = widget.fotos ?? FuenteFotosImagePicker();
  late final AlmacenFotos _almacen = widget.almacen ?? AlmacenFotosLocal();
  late final FuenteUbicacion _ubicacion =
      widget.ubicacion ?? FuenteUbicacionGeolocator();

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
        Provider<FuenteFotos>.value(value: _fotos),
        Provider<AlmacenFotos>.value(value: _almacen),
        Provider<FuenteUbicacion>.value(value: _ubicacion),
        // '..cargar()' dispara la primera carga en cuanto se crea el ViewModel.
        ChangeNotifierProvider<ReportesViewModel>(
          create: (_) => ReportesViewModel(
            widget.repositorio,
            compartir: widget.compartir ?? ServicioCompartirSharePlus(),
            almacen: _almacen,
            exportar: widget.exportar ?? ServicioExportarSharePlus(),
          )..cargar(),
        ),
        ChangeNotifierProvider<PrivacidadViewModel>(
          // lazy: false · se crea (y lee la preferencia) al abrir la app, no
          // en el primer toque de «Reportar»: si no, ese toque encontraría
          // «aceptado» todavía en falso y mostraría el aviso otra vez.
          lazy: false,
          create: (_) => PrivacidadViewModel(
            widget.preferencias ?? PreferenciasSharedPreferences(),
          )..cargar(),
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
