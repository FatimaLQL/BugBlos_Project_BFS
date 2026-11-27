import 'package:flutter/material.dart';
import 'package:mi_aplicacion/data/database_helper.dart';
import 'package:mi_aplicacion/data/sesion_usuario.dart';
import 'package:mi_aplicacion/screens/screen1.dart';
import 'package:mi_aplicacion/theme/app_theme.dart';

class ConfiguracionCuentaScreen extends StatefulWidget {
  const ConfiguracionCuentaScreen({super.key});

  @override
  State<ConfiguracionCuentaScreen> createState() =>
      _ConfiguracionCuentaScreenState();
}

class _ConfiguracionCuentaScreenState extends State<ConfiguracionCuentaScreen> {
  late final TextEditingController _nombreController;
  late final TextEditingController _telefonoController;
  late final TextEditingController _correoController;
  final TextEditingController _passwordActualController =
      TextEditingController();
  final TextEditingController _passwordNuevaController =
      TextEditingController();

  bool _ocultarActual = true;
  bool _ocultarNueva = true;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: SesionUsuario.nombre);
    _telefonoController = TextEditingController(text: SesionUsuario.telefono);
    _correoController = TextEditingController(text: SesionUsuario.correo);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    _correoController.dispose();
    _passwordActualController.dispose();
    _passwordNuevaController.dispose();
    super.dispose();
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  Future<void> _guardarPerfil() async {
    final id = SesionUsuario.id;
    final nombre = _nombreController.text.trim();
    final telefono = _telefonoController.text.trim();

    if (id == null) {
      _mostrarMensaje('No hay una sesión activa');
      return;
    }
    if (nombre.isEmpty) {
      _mostrarMensaje('El nombre no puede estar vacío');
      return;
    }

    setState(() => _guardando = true);
    try {
      await DatabaseHelper.instance.actualizarPerfil(id, nombre, telefono);
      SesionUsuario.nombre = nombre;
      SesionUsuario.telefono = telefono;

      if (!mounted) return;
      _mostrarMensaje('Datos guardados');
    } catch (e) {
      if (!mounted) return;
      _mostrarMensaje('No se pudieron guardar los datos');
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  Future<void> _cambiarPassword() async {
    final id = SesionUsuario.id;
    final actual = _passwordActualController.text.trim();
    final nueva = _passwordNuevaController.text.trim();

    if (id == null) {
      _mostrarMensaje('No hay una sesión activa');
      return;
    }
    if (actual.isEmpty || nueva.isEmpty) {
      _mostrarMensaje('Completa las dos contraseñas');
      return;
    }
    if (nueva.length < 6) {
      _mostrarMensaje('La nueva contraseña debe tener al menos 6 caracteres');
      return;
    }

    setState(() => _guardando = true);
    try {
      final cambiada = await DatabaseHelper.instance.cambiarPassword(
        id,
        actual,
        nueva,
      );

      if (!mounted) return;

      if (cambiada) {
        _passwordActualController.clear();
        _passwordNuevaController.clear();
        _mostrarMensaje('Contraseña actualizada');
      } else {
        _mostrarMensaje('La contraseña actual es incorrecta');
      }
    } catch (e) {
      if (!mounted) return;
      _mostrarMensaje('No se pudo cambiar la contraseña');
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  Future<void> _eliminarCuenta() async {
    final id = SesionUsuario.id;
    if (id == null) {
      _mostrarMensaje('No hay una sesión activa');
      return;
    }

    try {
      await DatabaseHelper.instance.eliminarUsuario(id);
      SesionUsuario.cerrar();

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Screen1()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      _mostrarMensaje('No se pudo eliminar la cuenta');
    }
  }

  void _confirmarEliminarCuenta() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.fondoTarjeta,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppTheme.borde),
        ),
        title: const Text('Eliminar cuenta'),
        content: const Text(
          'Esta acción no se puede deshacer. ¿Seguro que quieres continuar?',
          style: TextStyle(color: AppTheme.textoSecundario),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _eliminarCuenta();
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: AppTheme.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _seccion({
    required IconData icono,
    required String titulo,
    required List<Widget> hijos,
    Color color = AppTheme.moradoClaro,
    Color borde = AppTheme.borde,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.fondoTarjeta,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borde),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icono, color: color, size: 22),
              const SizedBox(width: 10),
              Text(
                titulo,
                style: TextStyle(
                  color: color == AppTheme.error
                      ? AppTheme.error
                      : AppTheme.textoPrincipal,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...hijos,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de cuenta'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Avatar
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 52,
                    backgroundColor: AppTheme.morado,
                    child: Icon(Icons.person, size: 62, color: Colors.white),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () =>
                          _mostrarMensaje('Cambiar foto (próximamente)'),
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppTheme.moradoClaro,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.fondo, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Datos personales
            _seccion(
              icono: Icons.person_outline,
              titulo: 'Datos personales',
              hijos: [
                TextField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre completo',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _correoController,
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _telefonoController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: _guardando ? null : _guardarPerfil,
                  child: const Text('Guardar cambios'),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Contraseña
            _seccion(
              icono: Icons.lock_outline,
              titulo: 'Cambiar contraseña',
              hijos: [
                TextField(
                  controller: _passwordActualController,
                  obscureText: _ocultarActual,
                  decoration: InputDecoration(
                    labelText: 'Contraseña actual',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => _ocultarActual = !_ocultarActual),
                      icon: Icon(
                        _ocultarActual
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppTheme.textoSecundario,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _passwordNuevaController,
                  obscureText: _ocultarNueva,
                  decoration: InputDecoration(
                    labelText: 'Nueva contraseña',
                    prefixIcon: const Icon(Icons.lock_reset),
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => _ocultarNueva = !_ocultarNueva),
                      icon: Icon(
                        _ocultarNueva
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppTheme.textoSecundario,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: _guardando ? null : _cambiarPassword,
                  child: const Text('Actualizar contraseña'),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Zona de peligro
            _seccion(
              icono: Icons.warning_amber_rounded,
              titulo: 'Zona de peligro',
              color: AppTheme.error,
              borde: AppTheme.error,
              hijos: [
                const Text(
                  'Al eliminar tu cuenta se borrarán tus datos de forma permanente.',
                  style: TextStyle(
                    color: AppTheme.textoSecundario,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: _confirmarEliminarCuenta,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Eliminar cuenta'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.error,
                    side: const BorderSide(color: AppTheme.error),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}