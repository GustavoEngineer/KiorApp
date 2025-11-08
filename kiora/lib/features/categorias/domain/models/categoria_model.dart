// Archivo: lib/features/categorias/domain/models/categoria_model.dart

class Categoria {
  final int? id; // Opcional para tareas que aún no están en la DB
  final String nombre;
  final int importancia; // ⚖️ La Variable I (Peso) para el Algoritmo (1-5)

  Categoria({this.id, required this.nombre, required this.importancia});

  // Método de conveniencia para debug o persistencia futura (opcional)
  @override
  String toString() {
    return 'Categoria(id: $id, nombre: $nombre, importancia: $importancia)';
  }
}
