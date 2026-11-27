import 'package:flutter/material.dart';

class NotificacionesData {
  static final List<Map<String, dynamic>> notificaciones = [
    {
      'titulo': 'Nuevo boletín de búsqueda',
      'mensaje': 'Se ha publicado un nuevo boletín de búsqueda.',
      'fecha': 'Hace 10 minutos',
      'icono': Icons.description_outlined,
      'leida': false,
    },
    {
      'titulo': 'Actualización de reporte',
      'mensaje': 'Tu información enviada ha sido recibida.',
      'fecha': 'Hace 1 hora',
      'icono': Icons.check_circle_outline,
      'leida': false,
    },
    {
      'titulo': 'Aviso importante',
      'mensaje': 'Hay nueva información disponible sobre una búsqueda.',
      'fecha': 'Ayer',
      'icono': Icons.campaign_outlined,
      'leida': true,
    },
  ];

  // Agregar una notificación cuando se actualiza un boletín.
  static void agregarActualizacion(String nombre) {
    notificaciones.insert(0, {
      'titulo': 'Boletín actualizado',
      'mensaje':
          'El boletín de búsqueda de $nombre fue actualizado correctamente.',
      'fecha': 'Ahora',
      'icono': Icons.edit_document,
      'leida': false,
    });
  }

  static int get pendientes =>
      notificaciones.where((n) => n['leida'] == false).length;
}
