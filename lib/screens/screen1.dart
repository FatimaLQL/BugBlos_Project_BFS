import 'package:flutter/material.dart';
import 'package:mi_aplicacion/screens/login_screen.dart';


class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF171329), Color(0xFF39206B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 40),

              // Logotipo
              const Icon(
                Icons.favorite,
                size: 85,
                color: Color.fromARGB(255, 76, 48, 151),
              ),

              // Títulos
              const Column(
                children: [
                  Text(
                    'BÚSQUEDA FAMILIAR',
                    style: TextStyle(
                      color: Colors.purpleAccent,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    'SEGURA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 45),

                  Text(
                    'Juntos por quienes\nnos faltan',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 19),
                  ),
                ],
              ),

              // Botón
              Padding(
                padding: const EdgeInsets.all(30),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Comenzar'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
