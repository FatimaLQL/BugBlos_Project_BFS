class PersonasData {
  static final List<Map<String, String>> personas = [
    {
      'nombre': 'Persona de ejemplo 1',
      'edad': '25 años',
      'sexo': 'Femenino',
      'fecha': '18/11/2020',
      'lugar': 'Mérida, Yucatán',
      'descripcion': 'Estatura: 154 cm\nComplexión: Delgada\nCabello: Rubio y lacio\nOjos: Verdes',
      'esMia': 'false',
    },
    {
      'nombre': 'Persona de ejemplo 2',
      'edad': '30 años',
      'sexo': 'Masculino',
      'fecha': '10/05/2023',
      'lugar': 'Valladolid, Yucatán',
      'descripcion':
          'Estatura: 165 cm\nComplexión: Media\nCabello: Castaño\nOjos: Cafés',
      'esMia': 'false',
    },
  ];

  static void agregarPersona(Map<String, String> persona) {
    personas.insert(0, persona);
  }
}
