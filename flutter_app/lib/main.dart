// main.dart
// Punto de entrada de la aplicación.
// Autora: Danna Ramirez

import 'package:flutter/material.dart';
import 'screens/lista_productos_screen.dart';

void main() {
  runApp(const InventarioApp());
}

class InventarioApp extends StatelessWidget {
  const InventarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventario Supermercado',
      debugShowCheckedModeBanner: false, // Quita la cinta roja de debug
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const ListaProductosScreen(),
    );
  }
}
