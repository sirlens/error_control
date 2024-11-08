class Item {
  final int id;
  final String nombre;
  double precio;
  int stock;
  final String grupo;

  Item({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.stock,
    required this.grupo,
  });

  // Copia del producto con valores actualizados (inmutable)
  Item copyWith({
    int? id,
    String? nombre,
    double? precio,
    int? stock,
    String? grupo,
  }) {
    return Item(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      stock: stock ?? this.stock,
      grupo: grupo ?? this.grupo,
    );
  }

  // Método para disminuir el stock
  void disminuirStock(int cantidad) {
    if (cantidad <= stock) {
      stock -= cantidad;
    } else {
      throw Exception('No hay suficiente stock');
    }
  }

  @override
  String toString() {
    return 'Producto{id: $id, nombre: $nombre, precio: $precio, stock: $stock, grupo: $grupo}';
  }
}