import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../comun/crear_reporte.dart';
import '../comun/logo.dart';
import '../reportes/exportar_listado.dart';
import '../reportes/reportes_viewmodel.dart';

/// Sprint 6 · Pantalla de inicio: quién es la app, para qué sirve y qué se
/// puede hacer con ella.
///
/// No es una pantalla de espera: se puede reportar desde el primer
/// segundo (RC-01). El botón principal, «Reportar un punto», va abajo y
/// fijo, como «Guardar reporte» en el formulario: lo importante, siempre
/// al alcance del pulgar.
class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  /// La promesa de la app, en palabras de la vecina.
  static const String eslogan = 'Tu barrio limpio empieza con una foto.';

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = Theme.of(context);
    final ReportesViewModel vm = context.watch<ReportesViewModel>();

    // Sin barra superior, la franja de la hora toma el color de la página
    // (y no un gris que la corta) con iconos que se leen en claro y oscuro.
    final SystemUiOverlayStyle franja =
        (tema.brightness == Brightness.dark
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark)
            .copyWith(statusBarColor: Colors.transparent);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: franja,
      child: Scaffold(
      bottomNavigationBar: const _BarraReportar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          children: <Widget>[
            const Align(
              alignment: AlignmentDirectional.centerStart,
              child: LogoEcoReporte(tamano: 80),
            ),
            const SizedBox(height: 16),
            Semantics(
              header: true,
              child: Text(
                'EcoReporte',
                style: tema.textTheme.headlineSmall?.copyWith(
                  fontSize: 40,
                  height: 1.1,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              eslogan,
              style: tema.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w400,
                color: tema.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            Card(
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: <Widget>[
                  _Opcion(
                    icono: Icons.photo_library_outlined,
                    titulo: 'Mis reportes',
                    detalle: _resumen(vm),
                    alPulsar: () => context.push('/reportes'),
                  ),
                  const Divider(height: 1),
                  _Opcion(
                    icono: Icons.download_outlined,
                    titulo: 'Listado del mes',
                    detalle: vm.estado == EstadoUi.listo
                        ? 'Para llevar a la empresa de aseo'
                        : 'Disponible cuando tengas reportes',
                    alPulsar: vm.estado == EstadoUi.listo && !vm.exportando
                        ? () => exportarListado(context, vm)
                        : null,
                  ),
                  const Divider(height: 1),
                  _Opcion(
                    icono: Icons.privacy_tip_outlined,
                    titulo: 'Privacidad',
                    detalle: 'Qué guarda la app y cuáles son tus derechos',
                    alPulsar: () => context.push('/privacidad'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }

  /// Lo que dice la opción «Mis reportes» según el estado de la lista.
  static String _resumen(ReportesViewModel vm) => switch (vm.estado) {
        EstadoUi.cargando => 'Cargando…',
        EstadoUi.error => 'No se pudieron leer. Ábrelo para reintentar.',
        EstadoUi.vacio => 'Aún no tienes reportes',
        EstadoUi.listo => vm.reportes.length == 1
            ? '1 guardado en este teléfono'
            : '${vm.reportes.length} guardados en este teléfono',
      };
}

/// Una opción del menú: icono, nombre y una línea que dice qué hay ahí.
class _Opcion extends StatelessWidget {
  const _Opcion({
    required this.icono,
    required this.titulo,
    required this.detalle,
    required this.alPulsar,
  });

  final IconData icono;
  final String titulo;
  final String detalle;
  final VoidCallback? alPulsar;

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = Theme.of(context);
    return ListTile(
      enabled: alPulsar != null,
      minVerticalPadding: 14,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(
        icono,
        color: alPulsar == null ? null : tema.colorScheme.primary,
      ),
      // Sin estilos propios: así ListTile atenúa el texto cuando la opción
      // está apagada («Listado del mes» sin reportes).
      title: Text(titulo),
      subtitle: Text(detalle),
      trailing: const Icon(Icons.chevron_right),
      onTap: alPulsar,
    );
  }
}

/// El botón principal de la app, abajo y fijo.
class _BarraReportar extends StatelessWidget {
  const _BarraReportar();

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = Theme.of(context);
    return Material(
      color: tema.colorScheme.surfaceContainer,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              FilledButton.icon(
                onPressed: () => crearReporte(context),
                icon: const Icon(Icons.add_a_photo_outlined, size: 26),
                label: const Text('Reportar un punto'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(64),
                  textStyle: tema.textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Se guarda en tu teléfono, aunque no tengas datos.',
                textAlign: TextAlign.center,
                style: tema.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
