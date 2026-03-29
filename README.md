# Inventario Supermercado - Flutter

Aplicación móvil desarrollada con Flutter para gestionar el inventario de un supermercado de pequeña superficie. Implementa operaciones CRUD con base de datos SQLite local.

## Autora
Danna Ramirez  
Programa: Análisis y Desarrollo de Software - SENA  
Evidencias: GA7-220501096-AA3-EV01 y GA7-220501096-AA3-EV02

## Tecnologías
- Flutter 3.x (lenguaje Dart)
- SQLite mediante paquete sqflite
- Compatible con Android e iOS

## Estructura del proyecto
- `flutter_app/lib/main.dart` → punto de entrada de la aplicación
- `flutter_app/lib/models/producto.dart` → clase Producto
- `flutter_app/lib/database/database_helper.dart` → operaciones CRUD
- `flutter_app/lib/screens/lista_productos_screen.dart` → pantalla principal
- `flutter_app/lib/screens/formulario_producto_screen.dart` → agregar y editar productos

## Cómo ejecutar
1. Instalar Flutter: https://docs.flutter.dev/get-started
2. Clonar este repositorio
3. Ejecutar en la terminal: `flutter pub get`
4. Conectar un dispositivo Android o abrir un emulador
5. Ejecutar: `flutter run`

## Funcionalidades implementadas
- Listar todos los productos del inventario
- Agregar nuevo producto con validaciones de campos
- Editar información de un producto existente
- Eliminar producto con diálogo de confirmación
