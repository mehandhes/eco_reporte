import 'dart:io';

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../data/compartir/servicio_compartir.dart';
import '../../domain/reporte.dart';
import '../comun/aviso.dart';
import '../comun/formatos.dart';
import '../reportes/reportes_viewmodel.dart';

/// HU-05 · Detalle de un reporte: foto en grande, fecha y hora, y lugar.
/// HU-10 · Desde aquí se comparte por WhatsApp (o cualquier otra app).
class PantallaDetalle extends StatelessWidget {
  const PantallaDetalle({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    final ReportesViewModel vm = context.watch<ReportesViewModel>();
    final Reporte? reporte = vm.buscar(id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte'),
        actions: <Widget>[
          if (reporte != null)
            IconButton(
              tooltip: 'Compartir',
              icon: const Icon(Icons.share_outlined),
              onPressed: vm.compartiendo(id) ? null : () => _compartir(context, vm),
            ),
          if (reporte != null)
            IconButton(
              tooltip: 'Borrar',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _borrar(context, vm),
            ),
        ],
      ),
      body: reporte == null
          ? const Aviso(
              icono: Icons.search_off,
              titulo: 'Este reporte ya no está',
              detalle: 'Vuelve a «Mis reportes» para ver los que tienes.',
            )
          : _Contenido(
              reporte: reporte,
              compartiendo: vm.compartiendo(id),
              alCompartir: () => _compartir(context, vm),
            ),
    );
  }

  /// TEC-05 · Borrar el reporte y su foto (derecho a suprimir). Se confirma
  /// antes, porque no se puede deshacer (heurística H5).
  Future<void> _borrar(BuildContext context, ReportesViewModel vm) async {
    final GoRouter navegador = GoRouter.of(context);
    final ScaffoldMessengerState mensajero = ScaffoldMessenger.of(context);
    final bool? confirmado = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogo) => AlertDialog(
        title: const Text('¿Borrar este reporte?'),
        content: const Text(
          'Se borran la foto y los datos de este teléfono. Lo que ya '
          'compartiste por WhatsApp no se borra. No se puede deshacer.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogo).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogo).pop(true),
            child: const Text('Borrar'),
          ),
        ],
      ),
    );
    if (confirmado != true) return;

    final bool borrado = await vm.eliminar(id);
    mensajero.showSnackBar(
      SnackBar(
        content: Text(borrado
            ? 'Reporte borrado.'
            : 'No se pudo borrar el reporte. Vuelve a intentarlo.'),
      ),
    );
    if (borrado) navegador.pop();
  }

  Future<void> _compartir(BuildContext context, ReportesViewModel vm) async {
    final ScaffoldMessengerState mensajero = ScaffoldMessenger.of(context);
    final ResultadoCompartir resultado = await vm.compartir(id);
    if (resultado == ResultadoCompartir.fallido) {
      mensajero.showSnackBar(
        const SnackBar(
          content: Text('No se pudo abrir el menú de compartir. '
              'Vuelve a intentarlo.'),
        ),
      );
    }
  }
}

class _Contenido extends StatelessWidget {
  const _Contenido({
    required this.reporte,
    required this.compartiendo,
    required this.alCompartir,
  });

  final Reporte reporte;
  final bool compartiendo;
  final VoidCallback alCompartir;

  @override
  Widget build(BuildContext context) {
    final String precision = formatearPrecision(reporte);
    final String coordenadas = precision.isEmpty
        ? formatearCoordenadas(reporte)
        : '${formatearCoordenadas(reporte)}  ($precision)';

    // SingleChildScrollView + textos que se parten: en 360 dp todo se lee
    // sin cortarse y sin desplazamiento lateral (escenario «Pantalla pequeña»).
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _FotoGrande(rutaFoto: reporte.rutaFoto),
          const SizedBox(height: 16),
          _Dato(
            icono: Icons.place_outlined,
            etiqueta: 'Lugar',
            valor: reporte.referencia.isEmpty
                ? 'Sin referencia escrita'
                : reporte.referencia,
          ),
          _Dato(
            icono: Icons.my_location,
            etiqueta: 'Coordenadas',
            valor: coordenadas,
          ),
          if (reporte.ubicacionAproximada)
            const _Dato(
              icono: Icons.warning_amber_outlined,
              etiqueta: 'Ubicación aproximada',
              valor: 'El GPS dio una precisión peor que 50 m. '
                  'La referencia del lugar ayuda a encontrarlo.',
            ),
          _Dato(
            icono: Icons.event_outlined,
            etiqueta: 'Fecha y hora',
            valor: formatearFechaYHora(reporte.fecha),
          ),
          if (reporte.fueCompartido)
            _Dato(
              icono: Icons.mark_chat_read_outlined,
              etiqueta: 'Compartido',
              valor: formatearFechaYHora(reporte.compartidoEn!),
            ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: compartiendo ? null : alCompartir,
            icon: const Icon(Icons.share_outlined),
            label: const Text('Compartir por WhatsApp'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Si no tienes WhatsApp, puedes elegir otra app. Sin datos, '
            'WhatsApp lo envía cuando vuelva la señal.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

/// La foto en grande (HU-05). Si el archivo ya no está, se dice en lugar
/// de romper la pantalla.
class _FotoGrande extends StatelessWidget {
  const _FotoGrande({required this.rutaFoto});

  final String? rutaFoto;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: rutaFoto == null
            ? const _SinFoto(texto: 'Sin foto en los datos de prueba')
            : Semantics(
                image: true,
                label: 'Foto del punto crítico',
                child: Image.file(
                  File(rutaFoto!),
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      const _SinFoto(texto: 'La foto ya no está en el teléfono'),
                ),
              ),
      ),
    );
  }
}

class _SinFoto extends StatelessWidget {
  const _SinFoto({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colores = Theme.of(context).colorScheme;
    return ColoredBox(
      color: colores.secondaryContainer,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.photo_outlined, size: 56, color: colores.onSecondaryContainer),
            const SizedBox(height: 8),
            Text(texto, style: TextStyle(color: colores.onSecondaryContainer)),
          ],
        ),
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  const _Dato({required this.icono, required this.etiqueta, required this.valor});

  final IconData icono;
  final String etiqueta;
  final String valor;

  @override
  Widget build(BuildContext context) {
    final TextTheme textos = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icono),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(etiqueta, style: textos.labelLarge),
                const SizedBox(height: 2),
                Text(valor, style: textos.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
