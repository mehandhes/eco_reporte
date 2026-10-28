import 'package:material_ui/material_ui.dart';

import '../../data/compartir/servicio_compartir.dart';
import '../comun/formatos.dart';
import 'reportes_viewmodel.dart';

/// HU-09 · Elige el mes y abre el menú de compartir con el listado.
/// Se usa desde «Mis reportes» y desde la pantalla de inicio.
Future<void> exportarListado(BuildContext context, ReportesViewModel vm) async {
  final ScaffoldMessengerState mensajero = ScaffoldMessenger.of(context);
  final DateTime? mes = await showDialog<DateTime>(
    context: context,
    builder: (BuildContext dialogo) => SimpleDialog(
      title: const Text('¿De qué mes es el listado?'),
      children: <Widget>[
        for (final DateTime opcion in vm.mesesExportables)
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24),
            leading: const Icon(Icons.calendar_month_outlined),
            title: Text(_capitalizar(formatearMes(opcion))),
            subtitle: Text(_reportes(vm.cuantosEn(opcion))),
            onTap: () => Navigator.of(dialogo).pop(opcion),
          ),
      ],
    ),
  );
  if (mes == null) return;

  final ResultadoCompartir resultado = await vm.exportarMes(mes);
  switch (resultado) {
    case ResultadoCompartir.compartido:
      mensajero.showSnackBar(
        SnackBar(
          content: Text('Listado de ${formatearMes(mes)} listo: '
              '${_reportes(vm.cuantosEn(mes))}.'),
        ),
      );
    case ResultadoCompartir.fallido:
      mensajero.showSnackBar(
        const SnackBar(
          content: Text('No se pudo preparar el listado. '
              'Vuelve a intentarlo.'),
        ),
      );
    case ResultadoCompartir.cancelado:
      break;
  }
}

String _reportes(int n) => n == 1 ? '1 reporte' : '$n reportes';

String _capitalizar(String texto) =>
    texto.isEmpty ? texto : texto[0].toUpperCase() + texto.substring(1);
