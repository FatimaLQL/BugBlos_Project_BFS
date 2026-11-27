import 'package:flutter/material.dart';

import 'package:mi_aplicacion/data/notificaciones_data.dart';
import 'package:mi_aplicacion/data/sesion_usuario.dart';

import 'perfil_usuario_screen.dart';
import 'screen3.dart';
import 'screen5.dart';
import 'screen7.dart';
import 'screen10.dart';

class Screen2 extends StatefulWidget {
  final String nombreUsuario;

  const Screen2({super.key, this.nombreUsuario = 'Usuario'});

  static const Color negroFondo = Color(0xFF080610);
  static const Color tarjetaFondo = Color(0xFF151020);
  static const Color moradoNeon = Color(0xFFBD35FF);
  static const Color bordeMorado = Color(0xFF482263);

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  int get pendientes => NotificacionesData.pendientes;

  Future<void> abrirNotificaciones() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const Screen5()),
    );

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> abrirReporte() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const Screen10()),
    );

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Screen2.negroFondo,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.favorite,
                    color: Screen2.moradoNeon,
                    size: 42,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Búsqueda Familiar Segura',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        onPressed: abrirNotificaciones,
                        icon: const Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                          size: 29,
                        ),
                      ),

                      if (pendientes > 0)
                        Positioned(
                          right: 3,
                          top: 2,
                          child: Container(
                            constraints: const BoxConstraints(
                              minWidth: 19,
                              minHeight: 19,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 215, 40, 215),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Screen2.negroFondo,
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                pendientes > 99 ? '99+' : '$pendientes',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 25),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7215B8), Color(0xFF21102F)],
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Screen2.bordeMorado),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      backgroundColor: Screen2.moradoNeon,
                      child: Icon(Icons.person, color: Colors.white, size: 42),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '¡Hola, ${SesionUsuario.nombre}!',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Juntos por un país más seguro.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                '¿Qué deseas realizar?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Selecciona una opción para continuar.',
                style: TextStyle(color: Colors.white60, fontSize: 14),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: tarjeta(
                      context,
                      Icons.people_outline,
                      'Personas desaparecidas',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Screen3()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: tarjeta(
                      context,
                      Icons.campaign_outlined,
                      'Reportar información',
                      abrirReporte,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Screen2.tarjetaFondo,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Screen2.bordeMorado),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.favorite, color: Screen2.moradoNeon, size: 35),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'La búsqueda nos une',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Comparte, ayuda y difunde información.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        backgroundColor: const Color(0xFF0D0A14),
        selectedItemColor: Screen2.moradoNeon,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
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

          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PerfilUsuarioScreen()),
            ).then((_) {
              if (mounted) setState(() {});
            });
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

  Widget tarjeta(
    BuildContext context,
    IconData icono,
    String texto,
    VoidCallback accion,
  ) {
    return InkWell(
      onTap: accion,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 155,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Screen2.tarjetaFondo,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Screen2.bordeMorado),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono, color: Screen2.moradoNeon, size: 43),
            const SizedBox(height: 15),
            Text(
              texto,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}