import 'package:go_router/go_router.dart';

import '../ui/detalle/pantalla_detalle.dart';
import '../ui/inicio/pantalla_inicio.dart';
import '../ui/nuevo/pantalla_nuevo_reporte.dart';
import '../ui/privacidad/pantalla_privacidad.dart';
import '../ui/reportes/pantalla_reportes.dart';

/// Todas las rutas de la app. El formulario y el detalle son hijos de '/'
/// para que el «atrás» del teléfono vuelva a la lista, en la misma posición
/// (HU-05).
///
/// Es una función y no una variable global para que cada prueba de widgets
/// empiece con un enrutador nuevo, en la ruta inicial.
///
/// Sprint 6: '/' es la pantalla de inicio y «Mis reportes» pasa a
/// '/reportes'. Las pruebas de «Mis reportes» arrancan ahí con [inicial].
GoRouter crearEnrutador({String inicial = '/'}) => GoRouter(
      initialLocation: inicial,
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (context, state) => const PantallaInicio(),
          routes: <RouteBase>[
            GoRoute(
              path: 'reportes',
              builder: (context, state) => const PantallaReportes(),
            ),
            GoRoute(
              path: 'nuevo',
              builder: (context, state) => const PantallaNuevoReporte(),
            ),
            GoRoute(
              // TEC-05 · '/privacidad?primera=1' antes del primer reporte.
              path: 'privacidad',
              builder: (context, state) => PantallaPrivacidad(
                antesDelPrimerReporte:
                    state.uri.queryParameters['primera'] == '1',
              ),
            ),
            GoRoute(
              path: 'reporte/:id',
              builder: (context, state) {
                final int id = int.tryParse(state.pathParameters['id'] ?? '') ?? -1;
                return PantallaDetalle(id: id);
              },
            ),
          ],
        ),
      ],
    );
