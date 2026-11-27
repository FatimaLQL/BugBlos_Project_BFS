import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('busqueda_familiar.db');
    return _database!;
  }

  Future<Database> _initDB(String nombreArchivo) async {
    final rutaDb = await getDatabasesPath();
    final rutaCompleta = join(rutaDb, nombreArchivo);

    return await openDatabase(
      rutaCompleta,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            correo TEXT NOT NULL UNIQUE,
            telefono TEXT,
            password TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // Registrar usuario
  Future<int> registrarUsuario(Map<String, dynamic> usuario) async {
    final db = await database;
    return await db.insert(
      'usuarios',
      usuario,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  // Iniciar sesión
  Future<Map<String, Object?>?> iniciarSesion(
    String correo,
    String password,
  ) async {
    final db = await database;
    final resultado = await db.query(
      'usuarios',
      where: 'correo = ? AND password = ?',
      whereArgs: [correo.trim(), password],
      limit: 1,
    );
    return resultado.isNotEmpty ? resultado.first : null;
  }
}