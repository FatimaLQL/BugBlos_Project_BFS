import 'package:flutter/material.dart';
import 'package:mi_aplicacion/theme/app_theme.dart';

class Screen7 extends StatefulWidget {
  const Screen7({super.key});

  @override
  State<Screen7> createState() => _Screen7State();
}

class _Screen7State extends State<Screen7> {
  final List<Map<String, String>> jornadas = [];

  final TextEditingController buscarController = TextEditingController();

  String filtroSeleccionado = 'Todas';

  List<Map<String, String>> get jornadasFiltradas {
    return jornadas.where((jornada) {
      final coincideBusqueda =
          (jornada['nombre'] ?? '').toLowerCase().contains(
            buscarController.text.toLowerCase(),
          ) ||
          (jornada['municipio'] ?? '').toLowerCase().contains(
            buscarController.text.toLowerCase(),
          );

      final coincideFiltro =
          filtroSeleccionado == 'Todas' ||
          jornada['estado'] == filtroSeleccionado;

      return coincideBusqueda && coincideFiltro;
    }).toList();
  }

  Future<void> registrarJornada({Map<String, String>? jornada}) async {
    // Protección: no permite editar jornadas ajenas.
    if (jornada != null && jornada['esMia'] != 'true') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No puedes editar una jornada publicada por otra persona.',
          ),
        ),
      );
      return;
    }

    final nombre = TextEditingController(text: jornada?['nombre'] ?? '');
    final fecha = TextEditingController(text: jornada?['fecha'] ?? '');
    final hora = TextEditingController(text: jornada?['hora'] ?? '');
    final municipio = TextEditingController(text: jornada?['municipio'] ?? '');
    final ubicacion = TextEditingController(text: jornada?['ubicacion'] ?? '');
    final organizador = TextEditingController(
      text: jornada?['organizador'] ?? '',
    );
    final descripcion = TextEditingController(
      text: jornada?['descripcion'] ?? '',
    );

    String estado = jornada?['estado'] ?? 'Programada';

    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, actualizarDialogo) {
            return AlertDialog(
              backgroundColor: AppTheme.fondoTarjeta,
              title: Text(
                jornada == null ? 'Nueva jornada' : 'Editar jornada',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SizedBox(
                width: 450,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        campo(nombre, 'Nombre de la jornada', Icons.event),
                        campo(
                          fecha,
                          'Fecha (DD/MM/AAAA)',
                          Icons.calendar_today,
                        ),
                        campo(hora, 'Hora de inicio', Icons.access_time),
                        campo(municipio, 'Municipio', Icons.location_city),
                        campo(
                          ubicacion,
                          'Punto de encuentro',
                          Icons.location_on,
                        ),
                        campo(
                          organizador,
                          'Nombre del organizador',
                          Icons.person_outline,
                        ),
                        campo(
                          descripcion,
                          'Descripción',
                          Icons.description,
                          maxLines: 3,
                        ),

                        const SizedBox(height: 12),

                        DropdownButtonFormField<String>(
                          value: estado,
                          dropdownColor: AppTheme.fondoTarjeta,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Estado de la jornada',
                            labelStyle: const TextStyle(color: Colors.white70),
                            prefixIcon: const Icon(
                              Icons.flag_outlined,
                              color: AppTheme.moradoClaro,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Programada',
                              child: Text('Programada'),
                            ),
                            DropdownMenuItem(
                              value: 'En curso',
                              child: Text('En curso'),
                            ),
                            DropdownMenuItem(
                              value: 'Finalizada',
                              child: Text('Finalizada'),
                            ),
                            DropdownMenuItem(
                              value: 'Cancelada',
                              child: Text('Cancelada'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              actualizarDialogo(() {
                                estado = value;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;

                    final datos = {
                      'nombre': nombre.text.trim(),
                      'fecha': fecha.text.trim(),
                      'hora': hora.text.trim(),
                      'municipio': municipio.text.trim(),
                      'ubicacion': ubicacion.text.trim(),
                      'organizador': organizador.text.trim(),
                      'descripcion': descripcion.text.trim(),
                      'estado': estado,

                      // Propietario de la jornada.
                      'esMia': jornada == null
                          ? 'true'
                          : (jornada['esMia'] ?? 'false'),
                    };

                    setState(() {
                      if (jornada == null) {
                        jornadas.insert(0, datos);
                      } else {
                        jornada.addAll(datos);
                      }
                    });

                    Navigator.pop(dialogContext);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.morado,
                  ),
                  child: const Text(
                    'Guardar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    await Future.delayed(const Duration(milliseconds: 300));

    nombre.dispose();
    fecha.dispose();
    hora.dispose();
    municipio.dispose();
    ubicacion.dispose();
    organizador.dispose();
    descripcion.dispose();
  }

  Widget campo(
    TextEditingController controller,
    String etiqueta,
    IconData icono, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Este campo es obligatorio';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: etiqueta,
          labelStyle: const TextStyle(color: Colors.white70),
          prefixIcon: Icon(icono, color: AppTheme.moradoClaro),
          filled: true,
          fillColor: AppTheme.fondo,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.borde),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppTheme.moradoClaro,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  void mostrarDetalles(Map<String, String> jornada) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.fondoTarjeta,
          title: Text(
            jornada['nombre'] ?? '',
            style: const TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                detalle(Icons.calendar_today, jornada['fecha'] ?? ''),
                detalle(Icons.access_time, jornada['hora'] ?? ''),
                detalle(Icons.location_city, jornada['municipio'] ?? ''),
                detalle(Icons.location_on, jornada['ubicacion'] ?? ''),
                detalle(Icons.person, jornada['organizador'] ?? ''),
                detalle(Icons.flag, jornada['estado'] ?? ''),
                const SizedBox(height: 12),
                const Text(
                  'Descripción',
                  style: TextStyle(
                    color: AppTheme.moradoClaro,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  jornada['descripcion'] ?? '',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cerrar',
                style: TextStyle(color: AppTheme.moradoClaro),
              ),
            ),
          ],
        );
      },
    );
  }

  void eliminarJornada(Map<String, String> jornada) {
    // Protección: no permite eliminar jornadas ajenas.
    if (jornada['esMia'] != 'true') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No puedes eliminar una jornada publicada por otra persona.',
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppTheme.fondoTarjeta,
          title: const Text(
            'Eliminar jornada',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            '¿Estás segura de que deseas eliminar esta jornada?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  jornadas.remove(jornada);
                });
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget detalle(IconData icono, String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          Icon(icono, color: AppTheme.moradoClaro, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Color colorEstado(String estado) {
    switch (estado) {
      case 'En curso':
        return Colors.blueAccent;
      case 'Finalizada':
        return AppTheme.exito;
      case 'Cancelada':
        return AppTheme.error;
      default:
        return AppTheme.moradoClaro;
    }
  }

  @override
  void dispose() {
    buscarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.fondo,
      appBar: AppBar(
        backgroundColor: AppTheme.fondo,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Jornadas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7215B8), Color(0xFF21102F)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.borde),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.groups, color: Colors.white, size: 38),
                  SizedBox(height: 12),
                  Text(
                    'Jornadas de búsqueda',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    'Organiza y consulta actividades de búsqueda y apoyo comunitario.',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Jornadas registradas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${jornadas.length}',
                  style: const TextStyle(
                    color: AppTheme.moradoClaro,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            TextField(
              controller: buscarController,
              style: const TextStyle(color: Colors.white),
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Buscar jornada o municipio...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppTheme.moradoClaro,
                ),
                filled: true,
                fillColor: AppTheme.fondoTarjeta,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppTheme.borde),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppTheme.borde),
                ),
              ),
            ),

            const SizedBox(height: 14),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    [
                      'Todas',
                      'Programada',
                      'En curso',
                      'Finalizada',
                      'Cancelada',
                    ].map((filtro) {
                      final seleccionado = filtroSeleccionado == filtro;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(filtro),
                          selected: seleccionado,
                          onSelected: (_) {
                            setState(() {
                              filtroSeleccionado = filtro;
                            });
                          },
                          selectedColor: AppTheme.morado,
                          backgroundColor: AppTheme.fondoTarjeta,
                          labelStyle: TextStyle(
                            color: seleccionado ? Colors.white : Colors.white70,
                            fontSize: 12,
                          ),
                          side: const BorderSide(color: AppTheme.borde),
                        ),
                      );
                    }).toList(),
              ),
            ),

            const SizedBox(height: 15),

            // Lista de jornadas.
            Expanded(
              child: jornadasFiltradas.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            size: 70,
                            color: AppTheme.moradoClaro.withValues(alpha: 0.7),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            jornadas.isEmpty
                                ? 'Todavía no hay jornadas'
                                : 'No se encontraron jornadas',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 7),
                          const Text(
                            'Registra una nueva jornada para comenzar.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: jornadasFiltradas.length,
                      itemBuilder: (context, index) {
                        final jornada = jornadasFiltradas[index];
                        final esMia = jornada['esMia'] == 'true';

                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.fondoTarjeta,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppTheme.borde),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.event_available,
                                    color: AppTheme.moradoClaro,
                                    size: 27,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      jornada['nombre'] ?? '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    color: AppTheme.fondoTarjeta,
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: Colors.white70,
                                    ),
                                    onSelected: (opcion) {
                                      if (opcion == 'detalles') {
                                        mostrarDetalles(jornada);
                                      } else if (opcion == 'editar') {
                                        registrarJornada(jornada: jornada);
                                      } else if (opcion == 'eliminar') {
                                        eliminarJornada(jornada);
                                      }
                                    },
                                    itemBuilder: (_) => [
                                      const PopupMenuItem(
                                        value: 'detalles',
                                        child: Text(
                                          'Ver detalles',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      if (esMia) ...[
                                        const PopupMenuItem(
                                          value: 'editar',
                                          child: Text(
                                            'Editar',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'eliminar',
                                          child: Text(
                                            'Eliminar',
                                            style: TextStyle(
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              detalle(
                                Icons.calendar_today,
                                jornada['fecha'] ?? '',
                              ),
                              detalle(Icons.access_time, jornada['hora'] ?? ''),
                              detalle(
                                Icons.location_on,
                                '${jornada['ubicacion']}, ${jornada['municipio']}',
                              ),

                              const SizedBox(height: 10),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: colorEstado(jornada['estado'] ?? '')
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  jornada['estado'] ?? '',
                                  style: TextStyle(
                                    color: colorEstado(jornada['estado'] ?? ''),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => registrarJornada(),
        backgroundColor: AppTheme.morado,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nueva jornada'),
      ),
    );
  }
}
