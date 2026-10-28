import 'package:material_ui/material_ui.dart';

import '../../domain/categoria.dart';
import 'nuevo_reporte_viewmodel.dart';

/// HU-06 · Tipo de residuo: seis botones, uno solo elegido, ninguno
/// obligatorio.
///
/// Botones a la vista y no una lista desplegable: se elige con un toque y
/// se ve de una vez qué opciones hay (heurística H6 · reconocer antes que
/// recordar).
class CampoCategoria extends StatelessWidget {
  const CampoCategoria({super.key, required this.vm});

  final NuevoReporteViewModel vm;

  @override
  Widget build(BuildContext context) {
    final TextTheme textos = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Tipo de residuo', style: textos.titleSmall),
        const SizedBox(height: 2),
        Text(
          'Opcional. Le dice a la empresa de aseo qué llevar.',
          style: textos.bodySmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: <Widget>[
            for (final Categoria categoria in Categoria.values)
              ChoiceChip(
                label: Text(categoria.nombre),
                selected: vm.categoria == categoria,
                // Área táctil de 48 dp aunque el botón se vea de 32 (TEC-04).
                materialTapTargetSize: MaterialTapTargetSize.padded,
                onSelected:
                    vm.guardando ? null : (_) => vm.alternarCategoria(categoria),
              ),
          ],
        ),
      ],
    );
  }
}
