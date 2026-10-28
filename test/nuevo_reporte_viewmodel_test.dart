import 'dart:async';

import 'package:eco_reporte/data/fotos/almacen_fotos.dart';
import 'package:eco_reporte/data/fotos/fuente_fotos.dart';
import 'package:eco_reporte/data/reporte_repository.dart';
import 'package:eco_reporte/data/ubicacion/fuente_ubicacion.dart';
import 'package:eco_reporte/domain/reporte.dart';
import 'package:eco_reporte/ui/nuevo/nuevo_reporte_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

import 'falsos.dart';

/// Los escenarios del formulario «Nuevo reporte», sobre el ViewModel.
void main() {
  late FuenteFotosFalsa fotos;
  late AlmacenFotosFalso almacen;
  late RepositorioFalso repositorio;
  late FuenteUbicacionFalsa ubicacion;
  late NuevoReporteViewModel vm;

  setUp(() {
    fotos = FuenteFotosFalsa();
    almacen = AlmacenFotosFalso();
    repositorio = RepositorioFalso();
    ubicacion = FuenteUbicacionFalsa();
    vm = NuevoReporteViewModel(
      fotos: fotos,
      almacen: almacen,
      repositorio: repositorio,
      ubicacion: ubicacion,
      reloj: () => DateTime(2026, 11, 2, 7, 30),
    );
  });

  /// Deja el formulario completo: foto y referencia.
  Future<void> llenar() async {
    await vm.tomarFoto();
    vm.referencia = '  Frente a la cancha, junto al poste  ';
  }

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

  group('HU-12 · Referencia del lugar', () {
    test('Sin ubicación, la referencia es obligatoria', () async {
      await vm.tomarFoto();
      expect(vm.referenciaObligatoria, isTrue);
      expect(vm.errorReferencia, isNull, reason: 'no se regaña antes de intentar');

      expect(await vm.guardar(), isNull);
      expect(vm.errorReferencia, isNotNull);
      expect(repositorio.reportes, isEmpty, reason: 'no se guarda nada');

      vm.referencia = 'frente a la cancha, junto al poste';
      expect(vm.errorReferencia, isNull);
      expect(vm.validar(), isTrue);
    });

    test('Solo espacios no cuenta como referencia', () async {
      await vm.tomarFoto();
      vm.referencia = '    ';
      expect(vm.validar(), isFalse);
    });
  });

  group('HU-03 · Guardar en el teléfono', () {
    test('Guardar: copia la foto, crea el reporte y lo devuelve', () async {
      await llenar();

      final Reporte? guardado = await vm.guardar();

      expect(guardado, isNotNull);
      expect(guardado!.rutaFoto, '/app/fotos/1.jpg',
          reason: 'la base guarda la ruta permanente, nunca la temporal');
      expect(guardado.referencia, 'Frente a la cancha, junto al poste');
      expect(guardado.fecha, DateTime(2026, 11, 2, 7, 30));
      expect(repositorio.reportes, hasLength(1));
    });

    test('Falta la foto: no se guarda nada y se dice qué falta', () async {
      vm.referencia = 'Frente a la cancha';

      expect(await vm.guardar(), isNull);

      expect(vm.errorFoto, contains('Falta la foto'));
      expect(almacen.guardadas, isEmpty);
      expect(repositorio.reportes, isEmpty);
    });

    test('Doble toque: se crea un solo reporte', () async {
      await llenar();
      repositorio.puerta = Completer<void>();

      final Future<Reporte?> primero = vm.guardar();
      final Reporte? segundo = await vm.guardar();
      repositorio.puerta!.complete();

      expect(segundo, isNull);
      expect(await primero, isNotNull);
      expect(repositorio.reportes, hasLength(1));
      expect(almacen.guardadas, hasLength(1));
    });

    test('Sin espacio: lo dice y conserva foto y referencia', () async {
      await llenar();
      almacen.error = const SinEspacio();

      expect(await vm.guardar(), isNull);

      expect(vm.errorGuardado, contains('espacio'));
      expect(vm.rutaFoto, '/tmp/foto_camara.jpg');
      expect(vm.referencia, contains('Frente a la cancha'));
      expect(vm.guardando, isFalse, reason: 'se puede volver a intentar');
    });

    test('Si la base falla, la foto copiada se borra y se puede reintentar', () async {
      await llenar();
      repositorio.errorAlGuardar = const ErrorDeGuardado('disco');

      expect(await vm.guardar(), isNull);
      expect(almacen.borradas, <String>['/app/fotos/1.jpg']);
      expect(vm.errorGuardado, isNotNull);

      repositorio.errorAlGuardar = null;
      expect(await vm.guardar(), isNotNull);
    });
  });

  group('HU-02 · Ubicación automática', () {
    test('Buena señal: coordenadas y precisión, y la referencia ya no es obligatoria', () async {
      ubicacion.resultado = buenaSenal;

      await vm.buscarUbicacion();

      expect(vm.estadoUbicacion, EstadoUbicacion.obtenida);
      expect(vm.latitud, 7.06531);
      expect(vm.precisionMetros, 8);
      expect(vm.ubicacionAproximada, isFalse);
      expect(vm.referenciaObligatoria, isFalse);
    });

    test('Se ve que está buscando, y mientras tanto se puede tomar la foto', () async {
      ubicacion.enCurso = Completer<ResultadoUbicacion>();

      final Future<void> busqueda = vm.buscarUbicacion();
      expect(vm.estadoUbicacion, EstadoUbicacion.buscando);

      await vm.tomarFoto();
      expect(vm.tieneFoto, isTrue);

      ubicacion.enCurso!.complete(buenaSenal);
      await busqueda;
      expect(vm.estadoUbicacion, EstadoUbicacion.obtenida);
    });

    test('Permiso denegado: se puede guardar con referencia y sin coordenadas', () async {
      await vm.buscarUbicacion();
      expect(vm.estadoUbicacion, EstadoUbicacion.sinPermiso);

      await llenar();
      final Reporte? guardado = await vm.guardar();

      expect(guardado, isNotNull);
      expect(guardado!.tieneUbicacion, isFalse);
    });

    test('Bloqueado para siempre: se ofrece abrir los ajustes de la app', () async {
      ubicacion.resultado = const SinPermisoDeUbicacion(bloqueado: true);

      await vm.buscarUbicacion();
      await vm.abrirAjustesDeLaApp();

      expect(vm.estadoUbicacion, EstadoUbicacion.bloqueada);
      expect(ubicacion.ajustesApp, 1);
    });

    test('Precisión peor que 50 m: se avisa y se puede pedir de nuevo', () async {
      ubicacion.resultado = const UbicacionObtenida(
        latitud: 7.06244,
        longitud: -73.85155,
        precisionMetros: 64,
      );
      await vm.buscarUbicacion();
      expect(vm.ubicacionAproximada, isTrue);

      ubicacion.resultado = buenaSenal;
      await vm.buscarUbicacion();
      expect(vm.ubicacionAproximada, isFalse);
      expect(ubicacion.veces, 2);
    });

    test('GPS apagado y sin señal son estados distintos', () async {
      ubicacion.resultado = const GpsApagado();
      await vm.buscarUbicacion();
      expect(vm.estadoUbicacion, EstadoUbicacion.gpsApagado);

      ubicacion.resultado = const SinSenalGps();
      await vm.buscarUbicacion();
      expect(vm.estadoUbicacion, EstadoUbicacion.sinSenal);
    });

    test('Si un reintento falla, se conserva la ubicación que ya había', () async {
      ubicacion.resultado = buenaSenal;
      await vm.buscarUbicacion();

      ubicacion.resultado = const SinSenalGps();
      await vm.buscarUbicacion();

      expect(vm.tieneUbicacion, isTrue);
      expect(vm.estadoUbicacion, EstadoUbicacion.obtenida);
    });

    test('El reporte guardado lleva las coordenadas y su precisión', () async {
      ubicacion.resultado = buenaSenal;
      await vm.buscarUbicacion();
      await vm.tomarFoto();

      final Reporte? guardado = await vm.guardar();

      expect(guardado!.latitud, 7.06531);
      expect(guardado.longitud, -73.85472);
      expect(guardado.precisionMetros, 8);
      expect(guardado.referencia, isEmpty, reason: 'con GPS, la referencia es opcional');
    });
  });
}
