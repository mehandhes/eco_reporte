import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../domain/reporte.dart';
import 'reporte_repository.dart';

/// TEC-02 · Repositorio de reportes sobre SQLite, dentro del teléfono.
///
/// Funciona sin conexión por diseño (HU-03): no hay servidor que esperar.
/// La fábrica y la ruta se pueden inyectar para que las pruebas usen una
/// base en memoria con `sqflite_common_ffi` (ver `test/repositorio_sqlite_test.dart`).
class RepositorioSqlite implements ReporteRepository {
  RepositorioSqlite({this._fabrica, this._ruta});

  static const String tabla = 'reportes';

  /// Sube en uno cada vez que cambie el esquema, y `_migrar` dice cómo
  /// pasar de la versión anterior a la nueva.
  ///
  /// * 1 · Sprint 2: la tabla `reportes`.
  /// * 2 · Sprint 3: columna `compartido_ms` (HU-10, hallazgo H1).
  static const int versionEsquema = 2;

  final DatabaseFactory? _fabrica;
  final String? _ruta;
  Future<Database>? _abriendo;

  /// Abre la base la primera vez que se necesita y la reutiliza después
  /// (inicialización perezosa). Guardar el Future, y no la base, evita
  /// abrirla dos veces si dos llamadas llegan a la vez.
  Future<Database> get _base => _abriendo ??= _abrir();

  Future<Database> _abrir() async {
    final DatabaseFactory fabrica = _fabrica ?? databaseFactory;
    final String ruta =
        _ruta ?? p.join(await fabrica.getDatabasesPath(), 'eco_reporte.db');
    return fabrica.openDatabase(
      ruta,
      options: OpenDatabaseOptions(
        version: versionEsquema,
        onCreate: _crear,
        onUpgrade: _migrar,
      ),
    );
  }

  static Future<void> _crear(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tabla (
        id           INTEGER PRIMARY KEY AUTOINCREMENT,
        fecha_ms     INTEGER NOT NULL,
        referencia   TEXT    NOT NULL DEFAULT '',
        latitud      REAL,
        longitud     REAL,
        precision_m  REAL,
        ruta_foto    TEXT,
        compartido_ms INTEGER
      )
    ''');
    // «Mis reportes» siempre ordena por fecha: el índice lo hace barato
    // aunque haya cientos de filas (RC-03).
    await db.execute('CREATE INDEX idx_${tabla}_fecha ON $tabla (fecha_ms)');
  }

  /// Lleva una base vieja a la versión actual sin perder reportes. Corre
  /// una vez, la primera vez que la versión nueva de la app abre la base.
  /// Cada paso es un `if` (y no un `else if`): una base en la versión 1
  /// pasa por todos los que le faltan.
  static Future<void> _migrar(Database db, int anterior, int nueva) async {
    if (anterior < 2) {
      await db.execute('ALTER TABLE $tabla ADD COLUMN compartido_ms INTEGER');
    }
  }

  @override
  Future<List<Reporte>> obtenerTodos() async {
    try {
      final Database db = await _base;
      final List<Map<String, Object?>> filas = await db.query(
        tabla,
        // El id desempata dos reportes guardados en el mismo milisegundo.
        orderBy: 'fecha_ms DESC, id DESC',
      );
      return filas.map(Reporte.desdeFila).toList();
    } catch (e) {
      throw ErrorDeLectura('$e');
    }
  }

  @override
  Future<Reporte> guardar(BorradorReporte borrador) async {
    try {
      final Database db = await _base;
      final int id = await db.insert(tabla, borrador.aFila());
      return borrador.conId(id);
    } catch (e) {
      throw ErrorDeGuardado('$e');
    }
  }

  @override
  Future<Reporte> marcarCompartido(int id, DateTime cuando) async {
    try {
      final Database db = await _base;
      final int cambiadas = await db.update(
        tabla,
        <String, Object?>{'compartido_ms': cuando.millisecondsSinceEpoch},
        where: 'id = ?',
        whereArgs: <Object>[id],
      );
      if (cambiadas == 0) throw ErrorDeGuardado('no existe el reporte $id');
      final List<Map<String, Object?>> filas =
          await db.query(tabla, where: 'id = ?', whereArgs: <Object>[id]);
      return Reporte.desdeFila(filas.single);
    } on ErrorDeGuardado {
      rethrow;
    } catch (e) {
      throw ErrorDeGuardado('$e');
    }
  }

  @override
  Future<void> eliminar(int id) async {
    try {
      final Database db = await _base;
      // Siempre con whereArgs, nunca pegando el valor en el texto del SQL:
      // así no hay inyección posible (OWASP M4).
      await db.delete(tabla, where: 'id = ?', whereArgs: <Object>[id]);
    } catch (e) {
      throw ErrorDeGuardado('$e');
    }
  }

  /// Cierra la base. Solo lo usan las pruebas.
  Future<void> cerrar() async {
    final Future<Database>? abriendo = _abriendo;
    _abriendo = null;
    if (abriendo != null) await (await abriendo).close();
  }
}
