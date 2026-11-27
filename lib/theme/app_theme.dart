import 'package:flutter/material.dart';

class AppTheme {
  // Fondos principales
  static const Color fondo = Color(0xFF080610);
  static const Color fondoTarjeta = Color(0xFF151020);

  // Morados
  static const Color morado = Color(0xFF962BFF);
  static const Color moradoClaro = Color(0xFFBD35FF);
  static const Color moradoOscuro = Color(0xFF35134F);

  // Bordes y separadores
  static const Color borde = Color(0xFF482263);

  // Textos
  static const Color textoPrincipal = Color(0xFFFFFFFF);
  static const Color textoSecundario = Color(0xFFBDB5C9);

  // Estados
  static const Color exito = Color(0xFF35D07F);
  static const Color advertencia = Color(0xFFFFC857);
  static const Color error = Color(0xFFFF5263);

  static ThemeData get tema {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: fondo,
      primaryColor: morado,

      colorScheme: const ColorScheme.dark(
        primary: moradoClaro,
        secondary: morado,
        surface: fondoTarjeta,
        error: error,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: fondo,
        foregroundColor: textoPrincipal,
        elevation: 0,
        centerTitle: false,
      ),

      cardTheme: CardThemeData(
        color: fondoTarjeta,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: borde),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: fondoTarjeta,
        labelStyle: const TextStyle(color: textoSecundario),
        hintStyle: const TextStyle(color: textoSecundario),
        prefixIconColor: moradoClaro,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borde),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: moradoClaro, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: morado,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: morado,
        foregroundColor: Colors.white,
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF0D0A14),
        selectedItemColor: moradoClaro,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: fondoTarjeta,
        contentTextStyle: const TextStyle(color: textoPrincipal),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      dividerColor: borde,
    );
  }
}
