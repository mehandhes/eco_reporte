import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../data/repositorio_simulado.dart';
import 'reportes_viewmodel.dart';

/// Menú de la barra superior para ver los cuatro estados en el teléfono.
/// Solo existe en modo de desarrollo (lo decide `main.dart`).
class SelectorEscenario extends StatelessWidget {
  const SelectorEscenario({super.key, required this.repositorio});

  final RepositorioSimulado repositorio;

  static String etiqueta(Escenario escenario) => switch (escenario) {
        Escenario.conDatos => 'Con datos',
        Escenario.vacio => 'Vacío',
        Escenario.falla => 'Falla al leer',
        Escenario.cargando => 'Cargando sin fin',
        Escenario.doscientos => 'Doscientos reportes',
      };

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Escenario>(
      tooltip: 'Escenario de prueba',
      icon: const Icon(Icons.science_outlined),
      onSelected: (Escenario elegido) {
        repositorio.escenario = elegido;
        context.read<ReportesViewModel>().cargar();
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Escenario>>[
        for (final Escenario escenario in Escenario.values)
          CheckedPopupMenuItem<Escenario>(
            value: escenario,
            checked: escenario == repositorio.escenario,
            child: Text(etiqueta(escenario)),
          ),
      ],
    );
  }
}
