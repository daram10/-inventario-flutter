// screens/lista_productos_screen.dart
// Pantalla principal: muestra la lista de todos los productos del inventario.
// Autora: Danna Ramirez

import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../database/database_helper.dart';
import 'formulario_producto_screen.dart';

class ListaProductosScreen extends StatefulWidget {
  const ListaProductosScreen({super.key});

  @override
  State<ListaProductosScreen> createState() => _ListaProductosScreenState();
}

class _ListaProductosScreenState extends State<ListaProductosScreen> {

  final DatabaseHelper _db = DatabaseHelper();
  List<Producto> _lista = [];

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  // Carga los productos desde la base de datos
  Future<void> _cargarProductos() async {
    final productos = await _db.listarProductos();
    setState(() {
      _lista = productos;
    });
  }

  // Eliminar producto con confirmación
  Future<void> _eliminarProducto(int id) async {
    // Mostrar diálogo de confirmación
    bool confirmar = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: const Text('¿Está seguro que desea eliminar este producto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await _db.eliminarProducto(id);
      _cargarProductos(); // Refrescar la lista
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto eliminado')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Barra superior
      appBar: AppBar(
        title: const Text('Inventario Supermercado'),
        backgroundColor: Colors.blueGrey[800],
        foregroundColor: Colors.white,
      ),

      // Lista de productos
      body: _lista.isEmpty
          ? const Center(child: Text('No hay productos registrados.'))
          : ListView.builder(
              itemCount: _lista.length,
              itemBuilder: (context, index) {
                final p = _lista[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    // Ícono de categoría
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueGrey[100],
                      child: Text(
                        p.categoria[0].toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Nombre y categoría
                    title: Text(p.nombre,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        '${p.categoria}  |  Cantidad: ${p.cantidad}'),
                    // Precio
                    trailing: Text(
                      '\$${p.precio.toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    // Opciones al mantener presionado
                    onLongPress: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.edit),
                              title: const Text('Editar'),
                              onTap: () async {
                                Navigator.pop(context);
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FormularioProductoScreen(
                                        producto: p),
                                  ),
                                );
                                _cargarProductos();
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.delete,
                                  color: Colors.red),
                              title: const Text('Eliminar',
                                  style: TextStyle(color: Colors.red)),
                              onTap: () {
                                Navigator.pop(context);
                                _eliminarProducto(p.id!);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),

      // Botón flotante para agregar producto
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey[800],
        foregroundColor: Colors.white,
        tooltip: 'Agregar producto',
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const FormularioProductoScreen(),
            ),
          );
          _cargarProductos(); // Refrescar al volver
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
