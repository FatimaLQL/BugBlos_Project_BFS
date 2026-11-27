import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mi_aplicacion/data/reportes_data.dart';
import 'package:mi_aplicacion/theme/app_theme.dart';

class Screen11 extends StatefulWidget {
  final Map<String, String> persona;

  const Screen11({super.key, required this.persona});

  @override
  State<Screen11> createState() => _Screen11State();
}

class _Screen11State extends State<Screen11> {
  bool get esMia => widget.persona['esMia'] == 'true';

  // Obtener solamente los reportes de esta persona.
  List<Map<String, String>> get reportesPersona {
    final idPersona = widget.persona['id'] ?? '';

    if (idPersona.isEmpty) return [];

    return ReportesData.reportes
        .where((reporte) => reporte['personaId'] == idPersona)
        .toList();
  }

  // Contar reportes pendientes.
  int get reportesPendientes {
    return reportesPersona
        .where((reporte) => reporte['estadoReporte'] != 'Revisado')
        .length;
  }

  // Abrir el detalle en una pantalla independiente.
  Future<void> consultarReporte(Map<String, String> reporte) async {
    final resultado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => DetalleReporteScreen(reporte: reporte)),
    );

    if (mounted && resultado == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!esMia) {
      return Scaffold(
        backgroundColor: AppTheme.fondo,
        appBar: AppBar(
          backgroundColor: AppTheme.fondo,
          foregroundColor: Colors.white,
          title: const Text('Acceso restringido'),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Text(
              'No tienes permiso para consultar estos reportes.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      );
    }

    final reportes = reportesPersona;

    return Scaffold(
      backgroundColor: AppTheme.fondo,
      appBar: AppBar(
        backgroundColor: AppTheme.fondo,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Reportes recibidos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: reportes.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 75,
                        color: AppTheme.moradoClaro.withValues(alpha: 0.7),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Todavía no hay reportes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Cuando alguien comparta información sobre '
                        'esta persona, aparecerá aquí.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white60, height: 1.5),
                      ),
                    ],
                  ),
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  Text(
                    'Reportes relacionados con '
                    '${widget.persona['nombre'] ?? 'esta persona'}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total: ${reportes.length} | '
                    'Pendientes: $reportesPendientes',
                    style: const TextStyle(
                      color: AppTheme.moradoClaro,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),

                  ...reportes.map((reporte) {
                    final revisado = reporte['estadoReporte'] == 'Revisado';

                    return Card(
                      color: AppTheme.fondoTarjeta,
                      margin: const EdgeInsets.only(bottom: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: const BorderSide(color: AppTheme.borde),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.visibility_outlined,
                                  color: AppTheme.moradoClaro,
                                  size: 25,
                                ),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Text(
                                    'Información recibida',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: revisado
                                        ? Colors.green.withValues(alpha: 0.2)
                                        : Colors.orange.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    revisado ? 'Revisado' : 'Pendiente',
                                    style: TextStyle(
                                      color: revisado
                                          ? Colors.greenAccent
                                          : Colors.orangeAccent,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Text(
                              '${reporte['fechaAvistamiento'] ?? 'Fecha no disponible'} • '
                              '${reporte['horaAvistamiento'] ?? 'Hora no disponible'}',
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              reporte['ubicacion'] ?? 'Ubicación no disponible',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              reporte['descripcion'] ?? 'Sin descripción',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white70,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 14),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () => consultarReporte(reporte),
                                icon: const Icon(Icons.visibility_outlined),
                                label: const Text('Consultar reporte completo'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppTheme.moradoClaro,
                                  side: const BorderSide(
                                    color: AppTheme.moradoClaro,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
      ),
    );
  }
}

class DetalleReporteScreen extends StatefulWidget {
  final Map<String, String> reporte;

  const DetalleReporteScreen({super.key, required this.reporte});

  @override
  State<DetalleReporteScreen> createState() => _DetalleReporteScreenState();
}

class _DetalleReporteScreenState extends State<DetalleReporteScreen> {
  Map<String, String> get reporte => widget.reporte;

  bool get revisado => reporte['estadoReporte'] == 'Revisado';

  void marcarRevisado() {
    setState(() {
      reporte['estadoReporte'] = 'Revisado';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reporte marcado como revisado.')),
    );
  }

  // Mostrar cada dato.
  Widget detalle(String titulo, String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.fondoTarjeta,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borde),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              color: AppTheme.moradoClaro,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            valor,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rutaEvidencia = reporte['evidencia'] ?? '';

    final tieneEvidencia =
        rutaEvidencia.isNotEmpty && File(rutaEvidencia).existsSync();

    return Scaffold(
      backgroundColor: AppTheme.fondo,
      appBar: AppBar(
        backgroundColor: AppTheme.fondo,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Detalles del reporte',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Center(
              child: Icon(
                Icons.assignment_outlined,
                size: 65,
                color: AppTheme.moradoClaro,
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Información del avistamiento',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            detalle('Persona', reporte['persona']),
            detalle('Fecha del avistamiento', reporte['fechaAvistamiento']),
            detalle('Hora', reporte['horaAvistamiento']),
            detalle('Estado', reporte['estado']),
            detalle('Municipio', reporte['municipio']),
            detalle('Ubicación', reporte['ubicacion']),
            detalle('Descripción', reporte['descripcion']),
            detalle('Vestimenta y características', reporte['detalles']),
            detalle('Contacto', reporte['contacto']),

            const SizedBox(height: 5),

            if (tieneEvidencia) ...[
              const Text(
                'Evidencia fotográfica',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(
                  File(rutaEvidencia),
                  width: double.infinity,
                  height: 240,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'No se pudo cargar la fotografía.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ] else
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  'No se adjuntó evidencia fotográfica.',
                  style: TextStyle(color: Colors.white54),
                ),
              ),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: revisado
                    ? Colors.green.withValues(alpha: 0.15)
                    : Colors.orange.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    revisado
                        ? Icons.check_circle_outline
                        : Icons.pending_outlined,
                    color: revisado ? Colors.greenAccent : Colors.orangeAccent,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    revisado ? 'Reporte revisado' : 'Reporte pendiente',
                    style: TextStyle(
                      color: revisado
                          ? Colors.greenAccent
                          : Colors.orangeAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            if (!revisado)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: marcarRevisado,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Marcar como revisado'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.morado,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.moradoClaro,
                  side: const BorderSide(color: AppTheme.moradoClaro),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Volver a los reportes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
