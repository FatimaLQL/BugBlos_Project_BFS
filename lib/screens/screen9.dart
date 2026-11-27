import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';

import 'package:mi_aplicacion/theme/app_theme.dart';
import 'package:mi_aplicacion/data/boletines_data.dart';
import 'package:mi_aplicacion/screens/screen2.dart';

class Screen9 extends StatefulWidget {
  const Screen9({super.key});

  @override
  State<Screen9> createState() => _Screen9State();
}

class _Screen9State extends State<Screen9> {
  // Regresar directamente a la pantalla principal
  void volverInicio() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const Screen2()),
      (route) => false,
    );
  }

  // Actualizar la lista de boletines
  void actualizarLista() {
    setState(() {});
  }

  // Formato de fecha de publicación
  String fechaPublicacion(String? fecha) {
    if (fecha == null || fecha.isEmpty) {
      return 'Sin fecha';
    }

    try {
      final DateTime fechaConvertida = DateTime.parse(fecha);

      return '${fechaConvertida.day.toString().padLeft(2, '0')}/'
          '${fechaConvertida.month.toString().padLeft(2, '0')}/'
          '${fechaConvertida.year}';
    } catch (e) {
      return fecha;
    }
  }

  // Mostrar un dato de la persona
  Widget dato(String titulo, String valor, IconData icono) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, size: 18, color: AppTheme.morado),
          const SizedBox(width: 9),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 13, color: Colors.black87),
                children: [
                  TextSpan(
                    text: '$titulo: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: valor.isEmpty ? 'No especificado' : valor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Compartir el boletín como imagen
  Future<void> compartirBoletin(
    ScreenshotController controlador,
    Map<String, String> persona,
  ) async {
    try {
      final Uint8List? imagen = await controlador.capture(pixelRatio: 3);

      if (imagen == null) {
        return;
      }

      final archivo = XFile.fromData(
        imagen,
        mimeType: 'image/png',
        name: 'boletin_${persona['nombre'] ?? 'busqueda'}.png',
      );

      await SharePlus.instance.share(
        ShareParams(
          files: [archivo],
          text: 'Boletín de búsqueda: ${persona['nombre'] ?? ''}',
          subject: 'Boletín de búsqueda',
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo compartir el boletín: $e')),
      );
    }
  }

  // Tarjeta cuando todavía no existen boletines
  Widget pantallaVacia() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.campaign_outlined,
              size: 85,
              color: AppTheme.moradoClaro,
            ),
            const SizedBox(height: 20),
            const Text(
              'No hay boletines publicados',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Cuando publiques un boletín de búsqueda, '
              'aparecerá aquí.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  // Imagen de la persona con tamaño controlado
  Widget imagenPersona(String? ruta) {
    if (ruta != null && ruta.isNotEmpty) {
      final archivo = File(ruta);

      if (archivo.existsSync()) {
        return Center(
          child: Container(
            width: 150,
            height: 180,
            margin: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borde, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Image.file(
                archivo,
                width: 150,
                height: 180,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return imagenPredeterminada();
                },
              ),
            ),
          ),
        );
      }
    }

    return imagenPredeterminada();
  }

  // Imagen predeterminada
  Widget imagenPredeterminada() {
    return Center(
      child: Container(
        width: 150,
        height: 180,
        margin: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.moradoClaro.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borde),
        ),
        child: Icon(Icons.person, size: 85, color: AppTheme.morado),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final boletines = BoletinesData.boletines;

    return WillPopScope(
      onWillPop: () async {
        volverInicio();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppTheme.fondo,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppTheme.morado,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: volverInicio,
          ),
          title: const Text(
            'Boletines publicados',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              tooltip: 'Actualizar',
              icon: const Icon(Icons.refresh),
              onPressed: actualizarLista,
            ),
          ],
        ),

        body: boletines.isEmpty
            ? pantallaVacia()
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: boletines.length,
                itemBuilder: (context, index) {
                  final persona = boletines[index];

                  final ScreenshotController controlador =
                      ScreenshotController();

                  return Card(
                    color: AppTheme.fondoTarjeta,
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(color: AppTheme.borde),
                    ),
                    child: Column(
                      children: [
                        // Encabezado de la tarjeta
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.campaign, color: AppTheme.morado),
                              const SizedBox(width: 9),
                              const Expanded(
                                child: Text(
                                  'Boletín de búsqueda',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert),
                                onSelected: (opcion) {
                                  if (opcion == 'compartir') {
                                    compartirBoletin(controlador, persona);
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'compartir',
                                    child: Row(
                                      children: [
                                        Icon(Icons.share),
                                        SizedBox(width: 10),
                                        Text('Compartir boletín'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Contenido del boletín
                        Screenshot(
                          controller: controlador,
                          child: Container(
                            color: AppTheme.fondoTarjeta,
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                imagenPersona(persona['foto']),

                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        persona['nombre'] ?? 'Sin nombre',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.moradoOscuro,
                                        ),
                                      ),

                                      const SizedBox(height: 15),

                                      dato(
                                        'Edad',
                                        persona['edad'] ?? '',
                                        Icons.person_outline,
                                      ),

                                      dato(
                                        'Lugar de desaparición',
                                        persona['lugar'] ?? '',
                                        Icons.location_on_outlined,
                                      ),

                                      dato(
                                        'Fecha de desaparición',
                                        persona['fecha'] ?? '',
                                        Icons.calendar_today_outlined,
                                      ),

                                      const Divider(height: 25),

                                      Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            color: Colors.green.shade700,
                                            size: 19,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'Publicado',
                                              style: TextStyle(
                                                color: Colors.green.shade700,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 8),

                                      Text(
                                        'Fecha de publicación: '
                                        '${fechaPublicacion(persona['fechaPublicacion'])}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
