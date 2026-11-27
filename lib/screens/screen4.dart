import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mi_aplicacion/data/personas_data.dart';
import 'package:mi_aplicacion/theme/app_theme.dart';
import 'package:mi_aplicacion/data/reportes_data.dart';

import 'screen6.dart';
import 'screen8.dart';
import 'screen11.dart';

class Screen4 extends StatefulWidget {
  final Map<String, String> persona;

  const Screen4({super.key, required this.persona});

  @override
  State<Screen4> createState() => _Screen4State();
}

class _Screen4State extends State<Screen4> {
  Map<String, String> get persona => widget.persona;

  bool huboCambios = false;

  bool get esMia => persona['esMia'] == 'true';

  int get cantidadReportes {
    final idPersona = persona['id'] ?? '';

    if (idPersona.isEmpty) return 0;

    return ReportesData.reportes
        .where((reporte) => reporte['personaId'] == idPersona)
        .length;
  }

  Future<void> abrirReportes() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Screen11(persona: persona)),
    );

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final String rutaFoto = persona['foto'] ?? '';

    final bool tieneFoto = rutaFoto.isNotEmpty && File(rutaFoto).existsSync();

    return Scaffold(
      backgroundColor: AppTheme.fondo,

      appBar: AppBar(
        title: const Text('Detalles de la persona'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, huboCambios),
        ),

        actions: [
          if (esMia) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Editar persona',
              onPressed: editarPersona,
            ),

            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              tooltip: 'Eliminar persona',
              onPressed: eliminarPersona,
            ),
          ],
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fotografía
              Center(
                child: Container(
                  width: 230,
                  height: 230,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppTheme.borde, width: 2),
                  ),
                  child: tieneFoto
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            File(rutaFoto),
                            width: 230,
                            height: 230,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          size: 150,
                          color: Colors.deepPurple,
                        ),
                ),
              ),

              const SizedBox(height: 25),

              // Nombre
              Text(
                persona['nombre'] ?? 'Nombre no disponible',
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 25),

              // Datos generales
              dato(
                Icons.person_outline,
                'Edad',
                persona['edad'] ?? 'No disponible',
              ),

              dato(
                Icons.location_on_outlined,
                'Última ubicación conocida',
                persona['lugar'] ?? 'No disponible',
              ),

              dato(
                Icons.calendar_month_outlined,
                'Fecha de desaparición',
                persona['fecha'] ?? 'No disponible',
              ),

              dato(
                Icons.wc_outlined,
                'Sexo',
                persona['sexo'] ?? 'No disponible',
              ),

              const SizedBox(height: 20),

              const Text(
                'Descripción física',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              tarjetaTexto(
                persona['descripcion']?.trim().isNotEmpty == true
                    ? persona['descripcion']!
                    : 'Sin descripción disponible',
              ),

              const SizedBox(height: 25),

              const Text(
                'Señas particulares',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              tarjetaTexto(
                persona['senas']?.trim().isNotEmpty == true
                    ? persona['senas']!
                    : 'Sin señas particulares registradas',
              ),

              const SizedBox(height: 30),

              if (esMia) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: abrirReportes,
                    icon: const Icon(Icons.assignment_outlined),
                    label: Text('Ver reportes recibidos ($cantidadReportes)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.fondoTarjeta,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppTheme.moradoClaro),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],

              // Compartir siempre está disponible.
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.share_outlined),
                  label: const Text('Compartir boletín de búsqueda'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.morado,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: compartirBoletin,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Editar persona
  Future<void> editarPersona() async {
    if (!esMia) return;

    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Screen6(persona: persona)),
    );

    if (resultado == true && mounted) {
      setState(() {
        huboCambios = true;
      });
    }
  }

  // Abrir pantalla para compartir boletín
  void compartirBoletin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Screen8(persona: persona)),
    );
  }

  // Eliminar persona
  Future<void> eliminarPersona() async {
    if (!esMia) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppTheme.fondoTarjeta,
          title: const Text(
            'Eliminar registro',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '¿Estás seguro de que deseas eliminar este registro? '
                'Esta acción no se puede deshacer.',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext, false);
                      },
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(dialogContext, true);
                      },
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Eliminar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (confirmar != true || !mounted) return;

    PersonasData.personas.remove(persona);

    Navigator.pop(context, true);
  }

  Widget dato(IconData icono, String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, color: AppTheme.moradoClaro, size: 26),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 5),
                Text(
                  valor,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tarjetaTexto(String texto) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppTheme.fondoTarjeta,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppTheme.borde),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 15,
          height: 1.6,
        ),
      ),
    );
  }

  void compartirInformacion(BuildContext context) {
    final informacion =
        '''
PERSONA DESAPARECIDA

Nombre: ${persona['nombre'] ?? 'No disponible'}
Edad: ${persona['edad'] ?? 'No disponible'}
Sexo: ${persona['sexo'] ?? 'No disponible'}
Última ubicación: ${persona['lugar'] ?? 'No disponible'}
Fecha de desaparición: ${persona['fecha'] ?? 'No disponible'}
Descripción física: ${persona['descripcion'] ?? 'No disponible'}
Señas particulares: ${persona['senas'] ?? 'No disponibles'}

Si tienes información, comunícate con las autoridades correspondientes.
''';

    Clipboard.setData(ClipboardData(text: informacion));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Información copiada, ahora puedes compartirla.'),
      ),
    );
  }
}
