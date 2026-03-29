// screens/formulario_producto_screen.dart
// Pantalla de formulario: sirve para INSERTAR un producto nuevo
// o ACTUALIZAR uno existente (si se pasa el parámetro 'producto').
// Autora: Danna Ramirez

import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../database/database_helper.dart';

class FormularioProductoScreen extends StatefulWidget {
  // Si 'producto' viene con datos, es una edición. Si viene null, es inserción.
  final Producto? producto;

  const FormularioProductoScreen({super.key, this.producto});

  @override
  State<FormularioProductoScreen> createState() =>
      _FormularioProductoScreenState();
}

class _FormularioProductoScreenState extends State<FormularioProductoScreen> {

  final _formKey    = GlobalKey<FormState>();
  final DatabaseHelper _db = DatabaseHelper();

  // Controladores de los campos del formulario
  final _nombreCtrl    = TextEditingController();
  final _categoriaCtrl = TextEditingController();
  final _precioCtrl    = TextEditingController();
  final _cantidadCtrl  = TextEditingController();

  bool _esEdicion = false;

  @override
  void initState() {
    super.initState();
    // Si hay un producto, pre-llenar los campos (modo edición)
    if (widget.producto != null) {
      _esEdicion = true;
      _nombreCtrl.text    = widget.producto!.nombre;
      _categoriaCtrl.text = widget.producto!.categoria;
      _precioCtrl.text    = widget.producto!.precio.toString();
      _cantidadCtrl.text  = widget.producto!.cantidad.toString();
    }
  }

  @override
  void dispose() {
    // Liberar los controladores al salir de la pantalla
    _nombreCtrl.dispose();
    _categoriaCtrl.dispose();
    _precioCtrl.dispose();
    _cantidadCtrl.dispose();
    super.dispose();
  }

  // Guardar el producto (insertar o actualizar)
  Future<void> _guardar() async {
    // Validar que todos los campos estén correctos
    if (!_formKey.currentState!.validate()) return;

    final producto = Producto(
      id:        _esEdicion ? widget.producto!.id : null,
      nombre:    _nombreCtrl.text.trim(),
      categoria: _categoriaCtrl.text.trim(),
      precio:    double.parse(_precioCtrl.text),
      cantidad:  int.parse(_cantidadCtrl.text),
    );

    if (_esEdicion) {
      await _db.actualizarProducto(producto);
    } else {
      await _db.insertarProducto(producto);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_esEdicion
              ? 'Producto actualizado correctamente'
              : 'Producto agregado correctamente'),
        ),
      );
      Navigator.pop(context); // Volver a la lista
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar Producto' : 'Nuevo Producto'),
        backgroundColor: Colors.blueGrey[800],
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              // Campo: Nombre
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre del producto',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.inventory),
                ),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'El nombre no puede estar vacío';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Campo: Categoría
              TextFormField(
                controller: _categoriaCtrl,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'La categoría no puede estar vacía';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Campo: Precio
              TextFormField(
                controller: _precioCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Precio',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'El precio no puede estar vacío';
                  }
                  if (double.tryParse(valor) == null) {
                    return 'Ingresa un número válido';
                  }
                  if (double.parse(valor) < 0) {
                    return 'El precio no puede ser negativo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Campo: Cantidad
              TextFormField(
                controller: _cantidadCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Cantidad en stock',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'La cantidad no puede estar vacía';
                  }
                  if (int.tryParse(valor) == null) {
                    return 'Ingresa un número entero';
                  }
                  if (int.parse(valor) < 0) {
                    return 'La cantidad no puede ser negativa';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Botón guardar
              ElevatedButton.icon(
                onPressed: _guardar,
                icon: const Icon(Icons.save),
                label: Text(_esEdicion ? 'Actualizar producto' : 'Guardar producto'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[800],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
