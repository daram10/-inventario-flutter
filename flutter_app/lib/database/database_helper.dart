// database/database_helper.dart
// Clase que gestiona la base de datos SQLite del dispositivo.
// SQLite guarda los datos directamente en el celular, sin necesitar servidor.
// Autora: Danna Ramirez

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/producto.dart';

class DatabaseHelper {

  // Abre la base de datos (la crea con la tabla si no existe)
  Future<Database> abrirBaseDeDatos() async {
    String ruta = join(await getDatabasesPath(), 'inventario.db');
    return await openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE productos (
            id        INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre    TEXT    NOT NULL,
            categoria TEXT    NOT NULL,
            precio    REAL    NOT NULL,
            cantidad  INTEGER NOT NULL
          )
        ''');
        // Datos de ejemplo
        await db.insert('productos', {'nombre': 'Arroz 1kg',       'categoria': 'Granos',      'precio': 2500, 'cantidad': 50});
        await db.insert('productos', {'nombre': 'Aceite 1L',       'categoria': 'Aceites',     'precio': 8900, 'cantidad': 30});
        await db.insert('productos', {'nombre': 'Leche 1L',        'categoria': 'Lacteos',     'precio': 3200, 'cantidad': 40});
        await db.insert('productos', {'nombre': 'Azucar 1kg',      'categoria': 'Endulzantes', 'precio': 1800, 'cantidad': 60});
        await db.insert('productos', {'nombre': 'Papel Higienico', 'categoria': 'Aseo',        'precio': 4500, 'cantidad': 25});
      },
    );
  }

  // CREATE - insertar producto
  Future<void> insertarProducto(Producto p) async {
    Database db = await abrirBaseDeDatos();
    await db.insert('productos', p.toMap());
    await db.close();
  }

  // READ - listar todos los productos
  Future<List<Producto>> listarProductos() async {
    Database db = await abrirBaseDeDatos();
    List<Map<String, dynamic>> filas = await db.query('productos');
    await db.close();
    return filas.map((f) => Producto.fromMap(f)).toList();
  }

  // UPDATE - actualizar un producto
  Future<void> actualizarProducto(Producto p) async {
    Database db = await abrirBaseDeDatos();
    await db.update('productos', p.toMap(), where: 'id = ?', whereArgs: [p.id]);
    await db.close();
  }

  // DELETE - eliminar un producto por ID
  Future<void> eliminarProducto(int id) async {
    Database db = await abrirBaseDeDatos();
    await db.delete('productos', where: 'id = ?', whereArgs: [id]);
    await db.close();
  }
}
