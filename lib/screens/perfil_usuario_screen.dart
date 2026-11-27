import 'package:flutter/material.dart';
import 'package:mi_aplicacion/data/sesion_usuario.dart';
import 'package:mi_aplicacion/screens/screen1.dart';
import 'package:mi_aplicacion/screens/screen3.dart';
import 'package:mi_aplicacion/screens/screen7.dart';
import 'package:mi_aplicacion/theme/app_theme.dart';
import 'package:mi_aplicacion/screens/configuracion_cuenta_screen.dart';

class PerfilUsuarioScreen extends StatefulWidget {
  const PerfilUsuarioScreen({super.key});

  @override
  State<PerfilUsuarioScreen> createState() => _PerfilUsuarioScreenState();
}

class _PerfilUsuarioScreenState extends State<PerfilUsuarioScreen> {
  void _proximamente(String titulo) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$titulo (próximamente)')),
    );
  }

  void _cerrarSesion() {
    SesionUsuario.cerrar();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Screen1()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de usuario'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 55,
              backgroundColor: AppTheme.morado,
              child: Icon(Icons.person, size: 65, color: Colors.white),
            ),
            const SizedBox(height: 14),
            Text(
              SesionUsuario.nombre,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppTheme.textoPrincipal,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _opcionPerfil(
              icono: Icons.settings,
              titulo: 'Configuración de cuenta',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ConfiguracionCuentaScreen(),
                  ),
                ).then((_) {
                  if (mounted) setState(() {});
                });
              },
            ),

            _opcionPerfil(
              icono: Icons.calendar_today,
              titulo: 'Jornadas unidas',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Screen7()),
                );
              },
            ),
            _opcionPerfil(
              icono: Icons.help_outline,
              titulo: 'Ayuda y soporte',
              onTap: () => _proximamente('Ayuda y soporte'),
            ),
            _opcionPerfil(
              icono: Icons.logout,
              titulo: 'Cerrar sesión',
              color: AppTheme.error,
              onTap: _cerrarSesion,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Screen3()),
            );
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Screen7()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Jornadas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  Widget _opcionPerfil({
    required IconData icono,
    required String titulo,
    required VoidCallback onTap,
    Color color = AppTheme.moradoClaro,
  }) {
    final esError = color == AppTheme.error;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        tileColor: AppTheme.fondoTarjeta,
        iconColor: color,
        textColor: esError ? AppTheme.error : AppTheme.textoPrincipal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: esError ? AppTheme.error : AppTheme.borde),
        ),
        leading: Icon(icono),
        title: Text(titulo, textAlign: TextAlign.center),
        onTap: onTap,
      ),
    );
  }
}