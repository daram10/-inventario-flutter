// modelo/producto.dart
// Clase que representa un producto del inventario.
// Autora: Danna Ramirez

class Producto {
  int?   id;
  String nombre;
  String categoria;
  double precio;
  int    cantidad;

  // Constructor
  Producto({
    this.id,
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.cantidad,
  });

  // Convertir un Producto a Map (para guardar en SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id':        id,
      'nombre':    nombre,
      'categoria': categoria,
      'precio':    precio,
      'cantidad':  cantidad,
    };
  }

  // Crear un Producto desde un Map (al leer de SQLite)
  factory Producto.fromMap(Map<String, dynamic> map) {
    return Producto(
      id:        map['id'],
      nombre:    map['nombre'],
      categoria: map['categoria'],
      precio:    map['precio'],
      cantidad:  map['cantidad'],
    );
  }
}
