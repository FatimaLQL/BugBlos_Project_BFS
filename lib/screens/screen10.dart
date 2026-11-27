import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mi_aplicacion/theme/app_theme.dart';
import 'package:mi_aplicacion/data/personas_data.dart';

//lo conectaremos a Firebase.
class ReportesData {
  static final List<Map<String, String>> reportes = [];
}

class Screen10 extends StatefulWidget {
  const Screen10({super.key});

  @override
  State<Screen10> createState() => _Screen10State();
}

class _Screen10State extends State<Screen10> {
  final formKey = GlobalKey<FormState>();

  final fechaController = TextEditingController();
  final horaController = TextEditingController();
  final estadoController = TextEditingController();
  final municipioController = TextEditingController();
  final ubicacionController = TextEditingController();
  final descripcionController = TextEditingController();
  final detallesController = TextEditingController();
  final contactoController = TextEditingController();

  final ImagePicker selectorImagen = ImagePicker();

  Map<String, String>? personaSeleccionada;
  XFile? imagenSeleccionada;

  bool enviando = false;

  Future<void> seleccionarImagen() async {
    final imagen = await selectorImagen.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (imagen != null) {
      setState(() {
        imagenSeleccionada = imagen;
      });
    }
  }

  void quitarImagen() {
    setState(() {
      imagenSeleccionada = null;
    });
  }

  void enviarReporte() {
    if (!formKey.currentState!.validate()) return;

    if (personaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona a la persona relacionada con el reporte.'),
        ),
      );
      return;
    }

    setState(() {
      enviando = true;
    });

    final nuevoReporte = <String, String>{
      'persona': personaSeleccionada!['nombre'] ?? '',
      'edadPersona': personaSeleccionada!['edad'] ?? '',
      'lugarDesaparicion': personaSeleccionada!['lugar'] ?? '',
      'fechaAvistamiento': fechaController.text.trim(),
      'horaAvistamiento': horaController.text.trim(),
      'estado': estadoController.text.trim(),
      'municipio': municipioController.text.trim(),
      'ubicacion': ubicacionController.text.trim(),
      'descripcion': descripcionController.text.trim(),
      'detalles': detallesController.text.trim(),
      'contacto': contactoController.text.trim(),
      'evidencia': imagenSeleccionada?.path ?? '',
      'estadoReporte': 'Pendiente',
      'fechaRegistro': DateTime.now().toString(),
    };

    ReportesData.reportes.insert(0, nuevoReporte);

    setState(() {
      enviando = false;
    });

    mostrarConfirmacion();
  }

  void mostrarConfirmacion() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppTheme.fondoTarjeta,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.greenAccent,
                size: 65,
              ),
              const SizedBox(height: 15),
              const Text(
                'Reporte registrado',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Tu información se ha guardado correctamente. '
                'Será necesario revisarla antes de utilizarla.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.morado,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    Navigator.pop(context, true);
                  },
                  child: const Text('Aceptar'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget campo({
    required TextEditingController controller,
    required String etiqueta,
    required IconData icono,
    String? hint,
    int maxLines = 1,
    bool obligatorio = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        validator: (value) {
          if (obligatorio && (value == null || value.trim().isEmpty)) {
            return 'Este campo es obligatorio';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: etiqueta,
          hintText: hint,
          labelStyle: const TextStyle(color: Colors.white70),
          hintStyle: const TextStyle(color: Colors.white38),
          prefixIcon: Icon(icono, color: AppTheme.moradoClaro),
          filled: true,
          fillColor: AppTheme.fondo,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: AppTheme.borde),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(
              color: AppTheme.moradoClaro,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget tituloSeccion(String titulo, String subtitulo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitulo,
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    fechaController.dispose();
    horaController.dispose();
    estadoController.dispose();
    municipioController.dispose();
    ubicacionController.dispose();
    descripcionController.dispose();
    detallesController.dispose();
    contactoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final personas = PersonasData.personas;

    return Scaffold(
      backgroundColor: AppTheme.fondo,

      appBar: AppBar(
        backgroundColor: AppTheme.fondo,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Reportar información',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
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
                    Icon(
                      Icons.visibility_outlined,
                      color: Colors.white,
                      size: 38,
                    ),
                    SizedBox(height: 12),
                    Text(
                      '¿Tienes información sobre alguien?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Si viste a una persona desaparecida o tienes '
                      'información que pueda ayudar a encontrarla, '
                      'compárte la información',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              tituloSeccion(
                '1. Persona relacionada',
                'Selecciona el caso sobre el que deseas informar.',
              ),

              DropdownButtonFormField<Map<String, String>>(
                value: personaSeleccionada,
                dropdownColor: AppTheme.fondoTarjeta,
                isExpanded: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Persona desaparecida',
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(
                    Icons.person_search,
                    color: AppTheme.moradoClaro,
                  ),
                  filled: true,
                  fillColor: AppTheme.fondo,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(color: AppTheme.borde),
                  ),
                ),
                hint: const Text(
                  'Seleccionar persona',
                  style: TextStyle(color: Colors.white54),
                ),
                items: personas.map((persona) {
                  return DropdownMenuItem<Map<String, String>>(
                    value: persona,
                    child: Text(
                      persona['nombre'] ?? 'Sin nombre',
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (persona) {
                  setState(() {
                    personaSeleccionada = persona;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Selecciona una persona';
                  }
                  return null;
                },
              ),

              if (personas.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Todavía no hay personas registradas para seleccionar.',
                    style: TextStyle(color: Colors.orangeAccent),
                  ),
                ),

              const SizedBox(height: 22),

              tituloSeccion(
                '2. Datos del avistamiento',
                'Indica cuándo y dónde viste a la persona.',
              ),

              campo(
                controller: fechaController,
                etiqueta: 'Fecha en que la viste',
                hint: 'DD/MM/AAAA',
                icono: Icons.calendar_today,
              ),

              campo(
                controller: horaController,
                etiqueta: 'Hora aproximada',
                hint: 'Ej. 6:30 PM',
                icono: Icons.access_time,
              ),

              campo(
                controller: estadoController,
                etiqueta: 'Estado',
                icono: Icons.map_outlined,
              ),

              campo(
                controller: municipioController,
                etiqueta: 'Municipio',
                icono: Icons.location_city,
              ),

              campo(
                controller: ubicacionController,
                etiqueta: 'Lugar específico',
                hint: 'Colonia, calle, establecimiento o referencia',
                icono: Icons.location_on_outlined,
              ),

              const SizedBox(height: 8),

              tituloSeccion(
                '3. ¿Qué fue lo que viste?',
                'Describe la situación con todos los detalles que recuerdes.',
              ),

              campo(
                controller: descripcionController,
                etiqueta: 'Descripción del avistamiento',
                hint:
                    'Cuéntanos qué ocurrió, hacia dónde se dirigía, '
                    'si estaba acompañada, etc.',
                icono: Icons.description_outlined,
                maxLines: 5,
              ),

              campo(
                controller: detallesController,
                etiqueta: 'Vestimenta y características adicionales',
                hint: 'Ej. Camisa roja, pantalón negro, mochila...',
                icono: Icons.checkroom_outlined,
                maxLines: 3,
                obligatorio: false,
              ),

              const SizedBox(height: 8),

              tituloSeccion(
                '4. Evidencia fotográfica',
                'Puedes adjuntar una imagen si cuentas con ella. Es opcional.',
              ),

              if (imagenSeleccionada != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.file(
                    File(imagenSeleccionada!.path),
                    height: 190,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: quitarImagen,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                    ),
                    label: const Text(
                      'Quitar imagen',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ),
              ] else
                InkWell(
                  onTap: seleccionarImagen,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    decoration: BoxDecoration(
                      color: AppTheme.fondoTarjeta,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppTheme.borde,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          color: AppTheme.moradoClaro,
                          size: 38,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Agregar fotografía',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Seleccionar desde tu galería',
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 22),

              tituloSeccion(
                '5. Datos de contacto',
                'Opcional. Comparte un medio seguro para que puedan '
                    'solicitarte más información.',
              ),

              campo(
                controller: contactoController,
                etiqueta: 'Teléfono o correo de contacto',
                hint: 'Información de contacto',
                icono: Icons.contact_phone_outlined,
                obligatorio: false,
              ),

              const SizedBox(height: 10),

              // Aviso de privacidad
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppTheme.morado.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppTheme.moradoClaro.withValues(alpha: 0.4),
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      color: AppTheme.moradoClaro,
                      size: 23,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Tu reporte contiene información '
                        'sensible. No compartas públicamente datos '
                        'personales. La información deberá '
                        'ser revisada por personas autorizadas.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: enviando ? null : enviarReporte,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.morado,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.send_outlined),
                  label: Text(
                    enviando ? 'Enviando...' : 'Enviar reporte',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
