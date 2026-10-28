import 'package:eco_reporte/data/repositorio_sqlite.dart';
import 'package:eco_reporte/domain/reporte.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// TEC-02 · El repositorio SQLite contra una base de verdad, en memoria.
///
/// `flutter test` corre en el computador, no en el teléfono: el plugin
/// sqflite no existe ahí. `sqflite_common_ffi` trae el mismo SQLite para
/// escritorio y el repositorio lo recibe por el constructor.
void main() {
  sqfliteFfiInit();

  late RepositorioSqlite repo;

  setUp(() {
    repo = RepositorioSqlite(
      fabrica: databaseFactoryFfi,
      ruta: inMemoryDatabasePath,
    );
  });

  tearDown(() => repo.cerrar());

  BorradorReporte borrador(DateTime fecha, String referencia) => BorradorReporte(
        fecha: fecha,
        referencia: referencia,
        rutaFoto: '/datos/fotos/$referencia.jpg',
      );

  test('una base nueva no tiene reportes', () async {
    expect(await repo.obtenerTodos(), isEmpty);
  });

  test('guardar devuelve el reporte con el id que asignó la base', () async {
    final Reporte guardado = await repo.guardar(
      BorradorReporte(
        fecha: DateTime(2026, 10, 30, 7, 15),
        referencia: 'Frente a la cancha, junto al poste',
        rutaFoto: '/datos/fotos/reporte_1.jpg',
        latitud: 7.06531,
        longitud: -73.85472,
        precisionMetros: 8,
      ),
    );

    expect(guardado.id, greaterThan(0));

    final List<Reporte> todos = await repo.obtenerTodos();
    expect(todos, hasLength(1));
    final Reporte leido = todos.single;
    expect(leido.id, guardado.id);
    expect(leido.fecha, DateTime(2026, 10, 30, 7, 15));
    expect(leido.referencia, 'Frente a la cancha, junto al poste');
    expect(leido.rutaFoto, '/datos/fotos/reporte_1.jpg');
    expect(leido.latitud, 7.06531);
    expect(leido.longitud, -73.85472);
    expect(leido.precisionMetros, 8);
  });

  test('sin ubicación, las coordenadas vuelven nulas (HU-02 · permiso negado)', () async {
    await repo.guardar(borrador(DateTime(2026, 10, 30), 'Esquina del colegio'));

    final Reporte leido = (await repo.obtenerTodos()).single;
    expect(leido.tieneUbicacion, isFalse);
    expect(leido.precisionMetros, isNull);
  });

  test('HU-04: del más reciente al más antiguo, sin importar el orden de guardado', () async {
    await repo.guardar(borrador(DateTime(2026, 10, 20), 'viejo'));
    await repo.guardar(borrador(DateTime(2026, 10, 29), 'nuevo'));
    await repo.guardar(borrador(DateTime(2026, 10, 25), 'medio'));

    final List<String> orden =
        (await repo.obtenerTodos()).map((Reporte r) => r.referencia).toList();
    expect(orden, <String>['nuevo', 'medio', 'viejo']);
  });

  test('RC-03: 200 reportes se leen en menos de un segundo', () async {
    final DateTime base = DateTime(2026, 10, 1);
    for (int i = 0; i < 200; i++) {
      await repo.guardar(borrador(base.add(Duration(hours: i)), 'punto $i'));
    }

    final Stopwatch reloj = Stopwatch()..start();
    final List<Reporte> todos = await repo.obtenerTodos();
    reloj.stop();

    expect(todos, hasLength(200));
    expect(todos.first.referencia, 'punto 199');
    // En el computador tarda unos milisegundos. El criterio de verdad se
    // mide en un Android de gama de entrada con DevTools (ver plan de pruebas).
    expect(reloj.elapsedMilliseconds, lessThan(1000));
  });

  test('ida y vuelta de la fila: aFila y desdeFila son inversas', () {
    final Reporte original = Reporte(
      id: 7,
      fecha: DateTime(2026, 11, 2, 18, 40),
      referencia: 'Orilla del caño',
      latitud: 7.06244,
      longitud: -73.85155,
      precisionMetros: 64,
      rutaFoto: '/datos/fotos/7.jpg',
    );

    final Reporte copia = Reporte.desdeFila(original.aFila());

    expect(copia.id, original.id);
    expect(copia.fecha, original.fecha);
    expect(copia.referencia, original.referencia);
    expect(copia.ubicacionAproximada, isTrue);
    expect(copia.rutaFoto, original.rutaFoto);
  });
}
