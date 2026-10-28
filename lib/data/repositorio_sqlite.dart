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
  RepositorioSqlite({DatabaseFactory? fabrica, String? ruta})
      : _fabrica = fabrica,
        _ruta = ruta;

  static const String tabla = 'reportes';

  /// Sube en uno cada vez que cambie el esquema, y `_migrar` dice cómo
  /// pasar de la versión anterior a la nueva.
  static const int versionEsquema = 1;

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
        ruta_foto    TEXT
      )
    ''');
    // «Mis reportes» siempre ordena por fecha: el índice lo hace barato
    // aunque haya cientos de filas (RC-03).
    await db.execute('CREATE INDEX idx_${tabla}_fecha ON $tabla (fecha_ms)');
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

  /// Cierra la base. Solo lo usan las pruebas.
  Future<void> cerrar() async {
    final Future<Database>? abriendo = _abriendo;
    _abriendo = null;
    if (abriendo != null) await (await abriendo).close();
  }
}
