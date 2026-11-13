class Product {
  final int id;
  final String name;
  final double price;
  final int stock;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      price: double.parse(json['price'].toString()),
      stock: int.parse(json['stock'].toString()),
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price.toString(),
      'stock': stock.toString(),
      'description': description,
    };
  }
}