class SesionUsuario {
  static int? id;
  static String nombre = 'Usuario';
  static String correo = '';
  static String telefono = '';

  static void iniciar(Map<String, Object?> usuario) {
    id = usuario['id'] as int?;
    final nombreBD = (usuario['nombre'] ?? '').toString().trim();
    nombre = nombreBD.isEmpty ? 'Usuario' : nombreBD;
    correo = (usuario['correo'] ?? '').toString();
    telefono = (usuario['telefono'] ?? '').toString();
  }

  static void cerrar() {
    id = null;
    nombre = 'Usuario';
    correo = '';
    telefono = '';
  }
}