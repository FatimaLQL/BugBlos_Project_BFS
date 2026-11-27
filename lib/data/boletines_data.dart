class BoletinesData {
  static final List<Map<String, String>> boletines = [];

  // Publicar un boletín nuevo
  static bool publicar(Map<String, String> persona) {
    final nombre = persona['nombre'] ?? '';
    final fecha = persona['fecha'] ?? '';

    final yaPublicado = boletines.any(
      (boletin) => boletin['nombre'] == nombre && boletin['fecha'] == fecha,
    );

    if (yaPublicado) {
      return false;
    }

    final nuevoBoletin = Map<String, String>.from(persona);

    nuevoBoletin['fechaPublicacion'] = DateTime.now().toString();

    boletines.insert(0, nuevoBoletin);

    return true;
  }

  // Actualizar un boletín que ya estaba publicado
  static bool actualizar(
    Map<String, String> datosAnteriores,
    Map<String, String> datosActualizados,
  ) {
    final nombreAnterior = datosAnteriores['nombre'] ?? '';
    final fechaAnterior = datosAnteriores['fecha'] ?? '';

    final indice = boletines.indexWhere(
      (boletin) =>
          boletin['nombre'] == nombreAnterior &&
          boletin['fecha'] == fechaAnterior,
    );

    // Si no estaba publicado, no se crea un boletín automáticamente.
    if (indice == -1) {
      return false;
    }

    // Conservar la fecha original de publicación.
    final fechaOriginal = boletines[indice]['fechaPublicacion'] ?? '';

    // Actualizar los datos del boletín existente.
    boletines[indice].addAll(datosActualizados);

    boletines[indice]['fechaPublicacion'] = fechaOriginal;
    boletines[indice]['fechaActualizacion'] = DateTime.now().toString();

    return true;
  }
}
