import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mi_aplicacion/data/database_helper.dart';
import 'package:mi_aplicacion/screens/screen2.dart';
import 'package:mi_aplicacion/theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _ocultarPassword = true;
  bool _aceptaTerminos = false;
  bool _cargando = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _telefonoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  Future<void> _registrar() async {
    final nombre = _nombreController.text.trim();
    final correo = _correoController.text.trim();
    final telefono = _telefonoController.text.trim();
    final password = _passwordController.text.trim();

    if (nombre.isEmpty || correo.isEmpty || password.isEmpty) {
      _mostrarMensaje('Completa nombre, correo y contraseña');
      return;
    }

    if (!_aceptaTerminos) {
      _mostrarMensaje('Marca la casilla para continuar');
      return;
    }

    setState(() => _cargando = true);

    try {
      await DatabaseHelper.instance.registrarUsuario({
        'nombre': nombre,
        'correo': correo,
        'telefono': telefono,
        'password': password,
      });

      if (!mounted) return;

      _mostrarMensaje('Usuario registrado con éxito');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Screen2(nombreUsuario: nombre),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _mostrarMensaje('Ese correo ya está registrado');
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear cuenta'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Únete a la comunidad',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: AppTheme.moradoClaro,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 22),
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
              keyboardType: TextInputType.emailAddress,
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
                labelText: 'Teléfono (opcional)',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(height: 14),
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
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: _aceptaTerminos,
                  activeColor: AppTheme.morado,
                  onChanged: (value) {
                    setState(() => _aceptaTerminos = value ?? false);
                  },
                ),
                const Expanded(
                  child: Text(
                    'Acepto los términos y el aviso de privacidad.',
                    style: TextStyle(
                      color: AppTheme.textoSecundario,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _cargando ? null : _registrar,
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
                      'Registrarse',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Ya tengo cuenta, volver a iniciar sesión',
                style: TextStyle(color: AppTheme.moradoClaro),
              ),
            ),
          ],
        ),
      ),
    );
  }
}