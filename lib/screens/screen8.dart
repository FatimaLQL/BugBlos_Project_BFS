import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cross_file/cross_file.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:gal/gal.dart';

import 'package:mi_aplicacion/theme/app_theme.dart';

class Screen8 extends StatefulWidget {
  final Map<String, String> persona;

  const Screen8({super.key, required this.persona});

  @override
  State<Screen8> createState() => _Screen8State();
}

class _Screen8State extends State<Screen8> {
  final ScreenshotController screenshotController = ScreenshotController();

  bool procesando = false;

  Map<String, String> get persona => widget.persona;

  @override
  Widget build(BuildContext context) {
    final rutaFoto = persona['foto'] ?? '';

    final tieneFoto = rutaFoto.isNotEmpty && File(rutaFoto).existsSync();

    return Scaffold(
      backgroundColor: AppTheme.fondo,
      appBar: AppBar(title: const Text('Boletín de búsqueda')),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Screenshot(
                controller: screenshotController,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.fondoTarjeta,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppTheme.morado, width: 2),
                  ),

                  child: Column(
                    children: [
                      const Text(
                        'BOLETÍN DE BÚSQUEDA',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'PERSONA DESAPARECIDA',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 210,
                        height: 210,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: tieneFoto
                            ? Image.file(File(rutaFoto), fit: BoxFit.cover)
                            : const Icon(
                                Icons.person,
                                size: 130,
                                color: Colors.deepPurple,
                              ),
                      ),
                      const SizedBox(height: 20),

                      Text(
                        (persona['nombre'] ?? 'Nombre no disponible')
                            .toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Divider(height: 30, color: Colors.white30),

                      _dato('Edad', persona['edad']),
                      _dato('Sexo', persona['sexo']),
                      _dato('Fecha de desaparición', persona['fecha']),
                      _dato('Última ubicación conocida', persona['lugar']),
                      _dato('Descripción física', persona['descripcion']),
                      _dato('Señas particulares', persona['senas']),

                      const SizedBox(height: 20),

                      const Text(
                        'Si cuentas con información que pueda '
                        'ayudar a localizar a esta persona, '
                        'repórtala por los canales oficiales '
                        'correspondientes.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: procesando ? null : compartirBoletin,
                  icon: procesando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.share_outlined),
                  label: Text(
                    procesando ? 'Preparando imagen...' : 'Compartir boletín',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.morado,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              PopupMenuButton<String>(
                enabled: !procesando,
                onSelected: (opcion) {
                  switch (opcion) {
                    case 'descargar':
                      descargarBoletin();
                      break;

                    case 'copiar':
                      copiarInformacion();
                      break;
                  }
                },

                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'descargar',
                    child: ListTile(
                      leading: Icon(Icons.download_outlined),
                      title: Text('Descargar imagen'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),

                  PopupMenuItem(
                    value: 'copiar',
                    child: ListTile(
                      leading: Icon(Icons.copy_outlined),
                      title: Text('Copiar información'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],

                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.more_horiz, color: AppTheme.moradoClaro),
                      const SizedBox(width: 8),
                      Text(
                        'Más opciones',
                        style: TextStyle(
                          color: AppTheme.moradoClaro,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dato(String titulo, String? valor) {
    final texto = valor?.trim().isNotEmpty == true ? valor! : 'No disponible';

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              titulo,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 4),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              texto,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  Future<Uint8List> generarImagen() async {
    await WidgetsBinding.instance.endOfFrame;

    final Uint8List? imagen = await screenshotController.capture(pixelRatio: 3);

    if (imagen == null || imagen.isEmpty) {
      throw Exception('No se pudo generar la imagen del boletín.');
    }

    return imagen;
  }

  Future<void> compartirBoletin() async {
    if (procesando) return;

    setState(() {
      procesando = true;
    });

    try {
      final Uint8List imagen = await generarImagen();

      final String nombreArchivo =
          'boletin_${DateTime.now().millisecondsSinceEpoch}.png';

      final archivo = XFile.fromData(
        imagen,
        mimeType: 'image/png',
        name: nombreArchivo,
      );

      final resultado = await SharePlus.instance.share(
        ShareParams(
          files: [archivo],
          fileNameOverrides: [nombreArchivo],
          text:
              'Boletín de búsqueda: '
              '${persona['nombre'] ?? ''}',
          subject: 'Boletín de búsqueda',
          sharePositionOrigin: Rect.fromLTWH(
            0,
            0,
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height,
          ),
        ),
      );

      if (!mounted) return;

      if (resultado.status == ShareResultStatus.unavailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No fue posible abrir las opciones para compartir.'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al compartir la imagen: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          procesando = false;
        });
      }
    }
  }

  Future<void> descargarBoletin() async {
    if (procesando) return;

    setState(() {
      procesando = true;
    });

    try {
      final imagen = await generarImagen();

      await Gal.putImageBytes(
        imagen,
        name: 'boletin_${DateTime.now().millisecondsSinceEpoch}',
        album: 'Busqueda Familiar Segura',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Boletín guardado en tu galería!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo guardar el boletín: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          procesando = false;
        });
      }
    }
  }

  void copiarInformacion() {
    final informacion =
        '''
BOLETÍN DE BÚSQUEDA
PERSONA DESAPARECIDA

Nombre: ${persona['nombre'] ?? 'No disponible'}
Edad: ${persona['edad'] ?? 'No disponible'}
Sexo: ${persona['sexo'] ?? 'No disponible'}
Fecha de desaparición: ${persona['fecha'] ?? 'No disponible'}
Última ubicación: ${persona['lugar'] ?? 'No disponible'}
Descripción física: ${persona['descripcion'] ?? 'No disponible'}
Señas particulares: ${persona['senas'] ?? 'No disponibles'}

Si cuentas con información, repórtala por los canales oficiales correspondientes.
''';

    Clipboard.setData(ClipboardData(text: informacion));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Información del boletín copiada.')),
    );
  }
}
