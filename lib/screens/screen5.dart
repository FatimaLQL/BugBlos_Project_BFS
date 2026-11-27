import 'package:flutter/material.dart';
import 'package:mi_aplicacion/theme/app_theme.dart';
import 'package:mi_aplicacion/data/notificaciones_data.dart';
import 'package:mi_aplicacion/data/personas_data.dart';

class Screen5 extends StatefulWidget {
  const Screen5({super.key});

  @override
  State<Screen5> createState() => _Screen5State();
}

class _Screen5State extends State<Screen5> {
  List<Map<String, dynamic>> get notificaciones {
    final idsPropios = PersonasData.personas
        .where((persona) => persona['esMia'] == 'true')
        .map((persona) => persona['id'] ?? '')
        .toSet();

    return NotificacionesData.notificaciones.where((notificacion) {
      final personaId = notificacion['personaId'];

      if (personaId == null) return true;

      return idsPropios.contains(personaId);
    }).toList();
  }

  int get pendientes => notificaciones.where((n) => n['leida'] == false).length;

  void marcarTodas() {
    setState(() {
      for (var notificacion in notificaciones) {
        notificacion['leida'] = true;
      }
    });
  }

  void cambiarEstado(int index) {
    setState(() {
      notificaciones[index]['leida'] =
          !(notificaciones[index]['leida'] as bool);
    });
  }

  void eliminarNotificacion(int index) {
    final notificacion = notificaciones[index];
    setState(() {
      NotificacionesData.notificaciones.remove(notificacion);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.fondo,
      appBar: AppBar(
        backgroundColor: AppTheme.fondo,
        elevation: 0,
        title: const Text(
          'Notificaciones',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.morado, AppTheme.moradoOscuro],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.notifications_active_outlined,
                  color: Colors.white,
                  size: 38,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mantente al tanto',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        pendientes == 0
                            ? 'No tienes notificaciones pendientes'
                            : 'Tienes $pendientes notificaciones sin leer',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                if (pendientes > 0)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$pendientes',
                      style: TextStyle(
                        color: AppTheme.moradoOscuro,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tus notificaciones',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: pendientes == 0 ? null : marcarTodas,
                  child: const Text('Marcar todas'),
                ),
              ],
            ),
          ),

          Expanded(
            child: notificaciones.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off_outlined,
                          size: 65,
                          color: AppTheme.morado.withOpacity(0.5),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No tienes notificaciones',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Aquí aparecerán tus avisos importantes',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: notificaciones.length,
                    itemBuilder: (context, index) {
                      final notificacion = notificaciones[index];
                      final bool leida = notificacion['leida'] as bool;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: leida
                              ? AppTheme.fondoTarjeta
                              : AppTheme.morado.withOpacity(0.09),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: leida
                                ? AppTheme.borde
                                : AppTheme.morado.withOpacity(0.4),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          leading: Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: AppTheme.morado.withOpacity(0.13),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              notificacion['icono'] as IconData,
                              color: AppTheme.morado,
                            ),
                          ),
                          title: Text(
                            notificacion['titulo'] as String,
                            style: TextStyle(
                              fontWeight: leida
                                  ? FontWeight.w500
                                  : FontWeight.bold,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(notificacion['mensaje'] as String),
                                const SizedBox(height: 7),
                                Text(
                                  notificacion['fecha'] as String,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (opcion) {
                              if (opcion == 'estado') {
                                cambiarEstado(index);
                              } else if (opcion == 'eliminar') {
                                eliminarNotificacion(index);
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'estado',
                                child: Text(
                                  leida
                                      ? 'Marcar como no leída'
                                      : 'Marcar como leída',
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'eliminar',
                                child: Text('Eliminar'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
