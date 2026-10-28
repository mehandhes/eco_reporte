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
      // del límite, y al acercarse el contador dice cuánto queda.
      maxLength: NuevoReporteViewModel.maxReferencia,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: 'Referencia del lugar',
        hintText: 'Frente a la cancha, junto al poste',
        // Sprint 6 · obligatoria u opcional, dicho en palabras.
        helperText: vm.referenciaObligatoria
            ? 'Obligatoria: sin ubicación, es lo que dirá dónde está el punto.'
            : vm.ubicacionAproximada
                ? 'Recomendada: la ubicación es aproximada. ¿Cómo lo '
                    'encuentra alguien que no es del barrio?'
                : 'Opcional. ¿Cómo lo encuentra alguien que no es del barrio?',
        helperMaxLines: 3,
        errorText: vm.errorReferencia,
        errorMaxLines: 3,
      ),
      buildCounter: (
        BuildContext context, {
        required int currentLength,
        required bool isFocused,
        required int? maxLength,
      }) {
        final int quedan = (maxLength ?? 0) - currentLength;
        // Sprint 6 · el contador aparece solo cuando faltan 30 o menos:
        // antes, ocupaba media fila y apretaba la ayuda en tres renglones.
        if (quedan > 30) return null;
        final String texto = quedan == 0
            ? 'Llegaste al límite de $maxLength caracteres'
            : 'Te quedan $quedan caracteres';
        return Text(texto, semanticsLabel: texto);
      },
    );
  }
}
