import 'package:flutter/services.dart' show MaxLengthEnforcement;
import 'package:material_ui/material_ui.dart';

import 'nuevo_reporte_viewmodel.dart';

/// HU-12 · Referencia del lugar: «frente a la cancha, junto al poste».
class CampoReferencia extends StatelessWidget {
  const CampoReferencia({super.key, required this.vm});

  final NuevoReporteViewModel vm;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: vm.referencia,
      onChanged: (String texto) => vm.referencia = texto,
      maxLines: 2,
      minLines: 1,
      // HU-12 · «Referencia demasiado larga»: no se puede escribir más allá
      // del límite, y el contador dice cuánto queda.
      maxLength: NuevoReporteViewModel.maxReferencia,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: vm.referenciaObligatoria
            ? 'Referencia del lugar *'
            : 'Referencia del lugar',
        hintText: 'Frente a la cancha, junto al poste',
        helperText: '¿Cómo lo encuentra alguien que no es del barrio?',
        helperMaxLines: 2,
        errorText: vm.errorReferencia,
        errorMaxLines: 3,
        border: const OutlineInputBorder(),
      ),
      buildCounter: (
        BuildContext context, {
        required int currentLength,
        required bool isFocused,
        required int? maxLength,
      }) {
        final int quedan = (maxLength ?? 0) - currentLength;
        final String texto = quedan == 0
            ? 'Llegaste al límite de $maxLength caracteres'
            : 'Te quedan $quedan caracteres';
        return Text(texto, semanticsLabel: texto);
      },
    );
  }
}
