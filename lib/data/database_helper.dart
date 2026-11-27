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

  // Registrar usuario (devuelve el id nuevo)
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

  // Actualizar nombre y teléfono
  Future<int> actualizarPerfil(int id, String nombre, String telefono) async {
    final db = await database;
    return await db.update(
      'usuarios',
      {'nombre': nombre, 'telefono': telefono},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Cambiar contraseña (true si la contraseña actual era correcta)
  Future<bool> cambiarPassword(int id, String actual, String nueva) async {
    final db = await database;
    final filas = await db.update(
      'usuarios',
      {'password': nueva},
      where: 'id = ? AND password = ?',
      whereArgs: [id, actual],
    );
    return filas > 0;
  }

  // Eliminar cuenta
  Future<int> eliminarUsuario(int id) async {
    final db = await database;
    return await db.delete(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}