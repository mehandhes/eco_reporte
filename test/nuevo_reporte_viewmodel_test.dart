import 'dart:async';

import 'package:eco_reporte/data/fotos/fuente_fotos.dart';
import 'package:eco_reporte/ui/nuevo/nuevo_reporte_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

import 'falsos.dart';

/// Los escenarios del formulario «Nuevo reporte», sobre el ViewModel.
void main() {
  late FuenteFotosFalsa fotos;
  late NuevoReporteViewModel vm;

  setUp(() {
    fotos = FuenteFotosFalsa();
    vm = NuevoReporteViewModel(fotos: fotos);
  });

  tearDown(() => vm.dispose());

  group('HU-01 · Tomar la foto', () {
    test('Foto tomada: queda en el formulario y se puede repetir', () async {
      await vm.tomarFoto();
      expect(vm.rutaFoto, '/tmp/foto_camara.jpg');

      fotos.alTomar = const FotoTomada('/tmp/otra.jpg');
      await vm.tomarFoto();
      expect(vm.rutaFoto, '/tmp/otra.jpg');
    });

    test('Permiso denegado: se explica y la galería sigue disponible', () async {
      fotos.alTomar = const CamaraDenegada();

      await vm.tomarFoto();
      expect(vm.camaraDenegada, isTrue);
      expect(vm.tieneFoto, isFalse);

      await vm.elegirDeGaleria();
      expect(vm.rutaFoto, '/tmp/foto_galeria.jpg');
      expect(vm.camaraDenegada, isFalse);
    });

    test('Cancelar no borra lo que ya había', () async {
      await vm.tomarFoto();
      fotos.alTomar = const FotoCancelada();

      await vm.tomarFoto();

      expect(vm.rutaFoto, '/tmp/foto_camara.jpg');
    });

    test('Si la cámara falla, se ofrece la galería en lenguaje llano', () async {
      fotos.alTomar = const FotoFallida('sin cámara');

      await vm.tomarFoto();

      expect(vm.avisoFoto, contains('galería'));
    });

    test('Mientras la cámara está abierta, un segundo toque no abre otra', () async {
      fotos.camaraAbierta = Completer<ResultadoFoto>();

      final Future<void> primera = vm.tomarFoto();
      await vm.tomarFoto();
      expect(fotos.vecesTomar, 1);
      expect(vm.pidiendoFoto, isTrue);

      fotos.camaraAbierta!.complete(const FotoTomada('/tmp/a.jpg'));
      await primera;
      expect(vm.pidiendoFoto, isFalse);
    });

    test('Una llamada larga: la foto que Android alcanzó a guardar se recupera', () async {
      fotos.perdida = '/tmp/recuperada.jpg';

      await vm.recuperarFotoPerdida();

      expect(vm.rutaFoto, '/tmp/recuperada.jpg');
    });
  });
}
