import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mi_aplicacion/data/database_helper.dart';
import 'package:mi_aplicacion/screens/screen2.dart';
import 'package:mi_aplicacion/screens/register_screen.dart';
import 'package:mi_aplicacion/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _ocultarPassword = true;
  bool _cargando = false;

  @override
  void dispose() {
    _correoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  Future<void> _iniciarSesion() async {
    final correo = _correoController.text.trim();
    final password = _passwordController.text.trim();

    if (correo.isEmpty || password.isEmpty) {
      _mostrarMensaje('Ingresa tu correo y contraseña');
      return;
    }

    setState(() => _cargando = true);

    try {
      final usuario = await DatabaseHelper.instance.iniciarSesion(
        correo,
        password,
      );

      if (!mounted) return;

      if (usuario != null) {
        final nombre = (usuario['nombre'] ?? '').toString().trim();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Screen2(
              nombreUsuario: nombre.isEmpty ? 'Usuario' : nombre,
            ),
          ),
        );
      } else {
        _mostrarMensaje('Correo o contraseña incorrectos');
      }
    } catch (e) {
      if (!mounted) return;
      _mostrarMensaje('Ocurrió un error al iniciar sesión');
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar sesión'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            const Icon(
              Icons.fingerprint,
              size: 76,
              color: AppTheme.morado,
            ),
            const SizedBox(height: 14),
            Text(
              'Búsqueda Familiar Segura',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: AppTheme.moradoClaro,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 28),
            TextField(
              controller: _correoController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: _ocultarPassword,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() => _ocultarPassword = !_ocultarPassword);
                  },
                  icon: Icon(
                    _ocultarPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: AppTheme.textoSecundario,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 26),
            ElevatedButton(
              onPressed: _cargando ? null : _iniciarSesion,
              child: _cargando
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Iniciar sesión',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '¿No tienes cuenta? ',
                  style: TextStyle(color: AppTheme.textoSecundario),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Regístrate',
                    style: TextStyle(
                      color: AppTheme.moradoClaro,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}