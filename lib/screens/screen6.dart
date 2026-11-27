import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:mi_aplicacion/theme/app_theme.dart';
import 'package:mi_aplicacion/data/personas_data.dart';
import 'package:mi_aplicacion/data/boletines_data.dart';
import 'package:mi_aplicacion/data/notificaciones_data.dart';

class Screen6 extends StatefulWidget {
  final Map<String, String>? persona;

  const Screen6({super.key, this.persona});

  @override
  State<Screen6> createState() => _Screen6State();
}

class _Screen6State extends State<Screen6> {
  final formularioKey = GlobalKey<FormState>();

  final nombreController = TextEditingController();
  final edadController = TextEditingController();
  final fechaController = TextEditingController();
  final estadoController = TextEditingController();
  final municipioController = TextEditingController();
  final lugarController = TextEditingController();
  final descripcionController = TextEditingController();
  final senasController = TextEditingController();

  final ImagePicker selectorImagen = ImagePicker();

  File? fotoSeleccionada;
  String fotoExistente = '';
  String? sexoSeleccionado;
  bool guardando = false;

  bool get modoEdicion => widget.persona != null;

  @override
  void initState() {
    super.initState();

    if (modoEdicion) {
      cargarDatosPersona();
    }
  }

  void cargarDatosPersona() {
    final persona = widget.persona!;

    nombreController.text = persona['nombre'] ?? '';
    edadController.text = persona['edad'] ?? '';
    fechaController.text = persona['fecha'] ?? '';
    descripcionController.text = persona['descripcion'] ?? '';
    senasController.text = persona['senas'] ?? '';

    fotoExistente = persona['foto'] ?? '';

    final sexo = persona['sexo'] ?? 'No especificado';

    const opcionesSexo = ['Femenino', 'Masculino', 'No especificado'];

    sexoSeleccionado = opcionesSexo.contains(sexo) ? sexo : 'No especificado';

    estadoController.text = persona['estado'] ?? '';
    municipioController.text = persona['municipio'] ?? '';
    lugarController.text = persona['ultimaUbicacion'] ?? '';

    if (estadoController.text.isEmpty &&
        municipioController.text.isEmpty &&
        lugarController.text.isEmpty) {
      final partes = (persona['lugar'] ?? '')
          .split(',')
          .map((parte) => parte.trim())
          .toList();

      if (partes.length >= 3) {
        lugarController.text = partes[0];
        municipioController.text = partes[1];
        estadoController.text = partes.sublist(2).join(', ');
      } else {
        lugarController.text = persona['lugar'] ?? '';
      }
    }
  }

  @override
  void dispose() {
    nombreController.dispose();
    edadController.dispose();
    fechaController.dispose();
    estadoController.dispose();
    municipioController.dispose();
    lugarController.dispose();
    descripcionController.dispose();
    senasController.dispose();

    super.dispose();
  }

  Future<void> seleccionarFoto() async {
    try {
      final XFile? imagen = await selectorImagen.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (imagen == null || !mounted) return;

      final directorio = await getApplicationDocumentsDirectory();

      final extension = imagen.path.contains('.')
          ? imagen.path.split('.').last
          : 'jpg';

      final nombreArchivo =
          'persona_${DateTime.now().microsecondsSinceEpoch}.$extension';

      final rutaPermanente = '${directorio.path}/$nombreArchivo';

      final imagenGuardada = await File(imagen.path).copy(rutaPermanente);

      if (!mounted) return;

      setState(() {
        fotoSeleccionada = imagenGuardada;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo seleccionar la fotografía: $e')),
      );
    }
  }

  Future<void> seleccionarFecha() async {
    DateTime fechaInicial = DateTime.now();

    if (fechaController.text.isNotEmpty) {
      try {
        final partes = fechaController.text.split('/');

        if (partes.length == 3) {
          fechaInicial = DateTime(
            int.parse(partes[2]),
            int.parse(partes[1]),
            int.parse(partes[0]),
          );
        }
      } catch (_) {
        fechaInicial = DateTime.now();
      }
    }

    if (fechaInicial.isAfter(DateTime.now())) {
      fechaInicial = DateTime.now();
    }

    final fecha = await showDatePicker(
      context: context,
      initialDate: fechaInicial,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      helpText: 'Fecha de desaparición',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.morado,
              surface: AppTheme.fondoTarjeta,
            ),
          ),
          child: child!,
        );
      },
    );

    if (fecha != null && mounted) {
      setState(() {
        fechaController.text =
            '${fecha.day.toString().padLeft(2, '0')}/'
            '${fecha.month.toString().padLeft(2, '0')}/'
            '${fecha.year}';
      });
    }
  }

  void guardarPersona() {
    if (guardando) return;

    if (!formularioKey.currentState!.validate()) return;

    final String rutaFoto = fotoSeleccionada?.path ?? fotoExistente;

    final Map<String, String> datosActualizados = {
      'id': modoEdicion
          ? (widget.persona!['id'] ??
                DateTime.now().microsecondsSinceEpoch.toString())
          : DateTime.now().microsecondsSinceEpoch.toString(),
      'nombre': nombreController.text.trim(),
      'edad': edadController.text.trim(),
      'sexo': sexoSeleccionado ?? 'No especificado',
      'fecha': fechaController.text.trim(),

      'estado': estadoController.text.trim(),
      'municipio': municipioController.text.trim(),
      'ultimaUbicacion': lugarController.text.trim(),

      'lugar':
          '${lugarController.text.trim()}, '
          '${municipioController.text.trim()}, '
          '${estadoController.text.trim()}',

      'descripcion': descripcionController.text.trim(),
      'senas': senasController.text.trim(),
      'foto': rutaFoto,
      'esMia': modoEdicion ? (widget.persona!['esMia'] ?? 'false') : 'true',
    };

    setState(() {
      guardando = true;
    });

    bool boletinActualizado = false;

    if (modoEdicion) {
      final datosAnteriores = Map<String, String>.from(widget.persona!);

      widget.persona!.addAll(datosActualizados);

      boletinActualizado = BoletinesData.actualizar(
        datosAnteriores,
        widget.persona!,
      );

      if (boletinActualizado) {
        NotificacionesData.agregarActualizacion(
          widget.persona!['nombre'] ?? 'Persona desaparecida',
        );
      }
    } else {
      PersonasData.agregarPersona(datosActualizados);
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          modoEdicion
              ? boletinActualizado
                    ? 'Registro y boletín actualizados correctamente.'
                    : 'Registro actualizado correctamente.'
              : 'Persona registrada correctamente.',
        ),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context, true);
  }

  Widget construirFoto() {
    if (fotoSeleccionada != null) {
      return Image.file(
        fotoSeleccionada!,
        width: 170,
        height: 170,
        fit: BoxFit.cover,
      );
    }

    if (fotoExistente.isNotEmpty && File(fotoExistente).existsSync()) {
      return Image.file(
        File(fotoExistente),
        width: 170,
        height: 170,
        fit: BoxFit.cover,
      );
    }

    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_a_photo_outlined, size: 55, color: AppTheme.moradoClaro),
        SizedBox(height: 8),
        Text('Agregar fotografía', style: TextStyle(color: Colors.white70)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.fondo,

      appBar: AppBar(
        title: Text(modoEdicion ? 'Editar persona' : 'Registrar persona'),
        centerTitle: true,
      ),

      body: Form(
        key: formularioKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Fotografía
            Center(
              child: GestureDetector(
                onTap: seleccionarFoto,
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    color: AppTheme.fondoTarjeta,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppTheme.borde, width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: construirFoto(),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Center(
              child: TextButton.icon(
                onPressed: seleccionarFoto,
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text('Seleccionar desde galería'),
              ),
            ),

            const SizedBox(height: 15),

            Text(
              modoEdicion
                  ? 'Actualizar información de la persona'
                  : 'Registro de persona desaparecida',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              modoEdicion
                  ? 'Modifica los datos que necesites.'
                  : 'Completa la información solicitada cuidadosamente.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white60),
            ),

            const SizedBox(height: 25),

            // Datos personales
            campo(
              'Nombre completo',
              nombreController,
              icono: Icons.person_outline,
            ),

            campo(
              'Edad',
              edadController,
              icono: Icons.cake_outlined,
              teclado: TextInputType.number,
              validar: (valor) {
                if (valor == null || valor.trim().isEmpty) {
                  return 'Ingresa la edad';
                }

                final edad = int.tryParse(valor.trim());

                if (edad == null || edad < 0 || edad > 120) {
                  return 'Ingresa una edad válida';
                }

                return null;
              },
            ),

            const SizedBox(height: 15),

            const Text('Sexo', style: TextStyle(color: Colors.white70)),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: sexoSeleccionado,
              dropdownColor: AppTheme.fondoTarjeta,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.wc),
                hintText: 'Selecciona una opción',
              ),
              items: const [
                DropdownMenuItem(value: 'Femenino', child: Text('Femenino')),
                DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
                DropdownMenuItem(
                  value: 'No especificado',
                  child: Text('Prefiero no especificarlo'),
                ),
              ],
              onChanged: (valor) {
                setState(() {
                  sexoSeleccionado = valor;
                });
              },
              validator: (valor) =>
                  valor == null ? 'Selecciona una opción' : null,
            ),

            const SizedBox(height: 18),

            // Fecha
            TextFormField(
              controller: fechaController,
              readOnly: true,
              onTap: seleccionarFecha,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Fecha de desaparición',
                prefixIcon: Icon(Icons.calendar_month),
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              validator: (valor) =>
                  valor == null || valor.isEmpty ? 'Selecciona la fecha' : null,
            ),

            const SizedBox(height: 18),

            const Divider(color: AppTheme.borde),

            // Ubicación
            const Text(
              'Ubicación',
              style: TextStyle(
                color: AppTheme.moradoClaro,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            campo('Estado', estadoController, icono: Icons.map_outlined),

            campo('Municipio', municipioController, icono: Icons.location_city),

            campo(
              'Última ubicación conocida',
              lugarController,
              icono: Icons.location_on_outlined,
            ),

            const Divider(color: AppTheme.borde),

            const Text(
              'Características de la persona',
              style: TextStyle(
                color: AppTheme.moradoClaro,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            campo(
              'Descripción física',
              descripcionController,
              icono: Icons.description_outlined,
              multilinea: true,
            ),

            campo(
              'Señas particulares',
              senasController,
              icono: Icons.fingerprint,
              multilinea: true,
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: guardando ? null : guardarPersona,
                icon: Icon(modoEdicion ? Icons.edit : Icons.save_outlined),
                label: Text(
                  modoEdicion ? 'Actualizar registro' : 'Guardar registro',
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget campo(
    String etiqueta,
    TextEditingController controller, {
    IconData? icono,
    TextInputType teclado = TextInputType.text,
    bool multilinea = false,
    String? Function(String?)? validar,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: TextFormField(
        controller: controller,
        keyboardType: multilinea ? TextInputType.multiline : teclado,
        maxLines: multilinea ? 4 : 1,
        minLines: 1,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: etiqueta,
          prefixIcon: icono == null ? null : Icon(icono),
          alignLabelWithHint: multilinea,
        ),
        validator:
            validar ??
            (valor) {
              if (valor == null || valor.trim().isEmpty) {
                return 'Este campo es obligatorio';
              }
              return null;
            },
      ),
    );
  }
}
