import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mi_aplicacion/theme/app_theme.dart';
import 'package:mi_aplicacion/data/personas_data.dart';

import 'screen4.dart';
import 'screen6.dart';

class Screen3 extends StatefulWidget {
  const Screen3({super.key});

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  final TextEditingController buscarController = TextEditingController();

  String busqueda = '';

  @override
  void dispose() {
    buscarController.dispose();
    super.dispose();
  }

  Future<void> publicarPersona() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const Screen6()),
    );

    if (resultado == true && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final personas = PersonasData.personas;

    final personasFiltradas = personas.where((persona) {
      final nombre = persona['nombre'] ?? '';

      return nombre.toLowerCase().contains(busqueda.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.fondo,

      appBar: AppBar(
        title: const Text('Personas desaparecidas'),
        centerTitle: true,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Búsqueda de personas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Consulta los registros de personas desaparecidas.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.65),
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 18),

                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: publicarPersona,
                    icon: const Icon(Icons.add_circle_outline, size: 18),
                    label: const Text('Publicar persona desaparecida'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.morado,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 11,
                        horizontal: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: buscarController,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (valor) {
                    setState(() {
                      busqueda = valor;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: busqueda.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              buscarController.clear();
                              setState(() {
                                busqueda = '';
                              });
                            },
                          )
                        : null,
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  '${personasFiltradas.length} personas registradas',
                  style: const TextStyle(
                    color: AppTheme.moradoClaro,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: personasFiltradas.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_search,
                          size: 75,
                          color: Colors.white.withOpacity(0.35),
                        ),

                        const SizedBox(height: 15),

                        Text(
                          busqueda.isNotEmpty
                              ? 'No se encontraron personas'
                              : 'No hay personas registradas',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Los registros aparecerán aquí.',
                          style: TextStyle(color: Colors.white38, fontSize: 13),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    itemCount: personasFiltradas.length,
                    itemBuilder: (context, index) {
                      final persona = personasFiltradas[index];

                      final String rutaFoto = persona['foto'] ?? '';

                      final bool tieneFoto =
                          rutaFoto.isNotEmpty && File(rutaFoto).existsSync();

                      return Card(
                        color: AppTheme.fondoTarjeta,
                        margin: const EdgeInsets.only(bottom: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: AppTheme.borde),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),

                          onTap: () async {
                            final resultado = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Screen4(persona: persona);
                                },
                              ),
                            );

                            if (resultado == true && mounted) {
                              setState(() {});
                            }
                          },

                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: SizedBox(
                                    width: 85,
                                    height: 95,
                                    child: tieneFoto
                                        ? Image.file(
                                            File(rutaFoto),
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stack) {
                                                  return imagenPredeterminada();
                                                },
                                          )
                                        : imagenPredeterminada(),
                                  ),
                                ),

                                const SizedBox(width: 14),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        persona['nombre'] ??
                                            'Nombre no disponible',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      Text(
                                        'Edad: ${persona['edad'] ?? 'No disponible'}',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13,
                                        ),
                                      ),

                                      const SizedBox(height: 5),

                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.location_on_outlined,
                                            color: AppTheme.moradoClaro,
                                            size: 17,
                                          ),

                                          const SizedBox(width: 4),

                                          Expanded(
                                            child: Text(
                                              persona['lugar'] ??
                                                  'Ubicación no disponible',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 8),

                                      const Text(
                                        'Ver detalles',
                                        style: TextStyle(
                                          color: AppTheme.moradoClaro,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: AppTheme.moradoClaro,
                                  size: 18,
                                ),
                              ],
                            ),
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

  Widget imagenPredeterminada() {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: const Icon(Icons.person, color: Colors.deepPurple, size: 55),
    );
  }
}
