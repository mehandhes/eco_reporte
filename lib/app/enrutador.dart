import 'package:go_router/go_router.dart';

import '../ui/detalle/pantalla_detalle.dart';
import '../ui/nuevo/pantalla_nuevo_reporte.dart';
import '../ui/reportes/pantalla_reportes.dart';

/// Todas las rutas de la app. El formulario y el detalle son hijos de '/'
/// para que el «atrás» del teléfono vuelva a la lista, en la misma posición
/// (HU-05).
///
/// Es una función y no una variable global para que cada prueba de widgets
/// empiece con un enrutador nuevo, en la ruta inicial.
GoRouter crearEnrutador() => GoRouter(
      initialLocation: '/',
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (context, state) => const PantallaReportes(),
          routes: <RouteBase>[
            GoRoute(
              path: 'nuevo',
              builder: (context, state) => const PantallaNuevoReporte(),
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
