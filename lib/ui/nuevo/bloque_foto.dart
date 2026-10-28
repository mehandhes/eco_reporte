import 'dart:io';

import 'package:material_ui/material_ui.dart';

import 'nuevo_reporte_viewmodel.dart';

/// HU-01 · La foto dentro del formulario: tomarla, verla en miniatura,
/// repetirla, o elegirla de la galería.
class BloqueFoto extends StatelessWidget {
  const BloqueFoto({super.key, required this.vm});

  final NuevoReporteViewModel vm;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colores = Theme.of(context).colorScheme;
    final bool ocupado = vm.pidiendoFoto;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AspectRatio(
          aspectRatio: 4 / 3,
          // Ink fuera e InkWell dentro: al revés, la onda del toque quedaría
          // pintada debajo del fondo y no se vería.
          child: Ink(
            decoration: BoxDecoration(
              color: colores.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colores.outlineVariant),
            ),
            child: InkWell(
              onTap: ocupado ? null : vm.tomarFoto,
              borderRadius: BorderRadius.circular(12),
              child: vm.rutaFoto == null
                  ? _SinFoto(ocupado: ocupado)
                  : _Miniatura(ruta: vm.rutaFoto!),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: <Widget>[
            if (vm.tieneFoto)
              TextButton.icon(
                onPressed: ocupado ? null : vm.tomarFoto,
                icon: const Icon(Icons.replay),
                label: const Text('Repetir foto'),
                style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
              ),
            TextButton.icon(
              onPressed: ocupado ? null : vm.elegirDeGaleria,
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('Elegir de la galería'),
              style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
            ),
          ],
        ),
        if (vm.camaraDenegada)
          const _Explicacion(
            texto: 'La foto muestra el estado real del lugar a quien va a '
                'recoger. Puedes permitir la cámara en los ajustes del '
                'teléfono o elegir una foto de la galería.',
          ),
        if (vm.avisoFoto != null) _Explicacion(texto: vm.avisoFoto!),
      ],
    );
  }
}

class _SinFoto extends StatelessWidget {
  const _SinFoto({required this.ocupado});

  final bool ocupado;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colores = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: 'Tomar la foto del punto',
      excludeSemantics: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (ocupado)
            const CircularProgressIndicator()
          else
            Icon(Icons.add_a_photo_outlined, size: 48, color: colores.primary),
          const SizedBox(height: 12),
          Text(
            'Toca para tomar la foto *',
            style: TextStyle(color: colores.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _Miniatura extends StatelessWidget {
  const _Miniatura({required this.ruta});

  final String ruta;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: 'Foto del punto. Toca para repetirla',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          File(ruta),
          fit: BoxFit.cover,
          width: double.infinity,
          // Decodifica a la medida de la pantalla, no a 1600 px.
          cacheWidth: 800,
          errorBuilder: (_, _, _) => const Center(
            child: Icon(Icons.broken_image_outlined, size: 48),
          ),
        ),
      ),
    );
  }
}

class _Explicacion extends StatelessWidget {
  const _Explicacion({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colores = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colores.secondaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.info_outline, color: colores.onSecondaryContainer),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              texto,
              style: TextStyle(color: colores.onSecondaryContainer),
            ),
          ),
        ],
      ),
    );
  }
}
