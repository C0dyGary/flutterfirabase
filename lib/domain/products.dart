class ListProducts {
  final List<Product> products;
  final String message;

  ListProducts({required this.products, required this.message});

  factory ListProducts.fromJson(Map<String, dynamic> json) => ListProducts(
    products: List<Product>.from(json["Data"].map((x) => Product.fromJson(x))),
    message: json["Message"],
  );

  Map<String, dynamic> toJson() => {
    "Product": List<dynamic>.from(products.map((x) => x.toJson())),
    "Message": message,
  };
}

class Product {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;
  final String name;
  final String description;
  final double price;
  final String image;
  final int stock;

  Product({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["ID"] ?? json["id"] ?? 0,
      createdAt: json["CreatedAt"] != null
          ? DateTime.parse(json["CreatedAt"])
          : DateTime.now(),
      updatedAt: json["UpdatedAt"] != null
          ? DateTime.parse(json["UpdatedAt"])
          : DateTime.now(),
      deletedAt: json["DeletedAt"],
      name: json["name"] ?? '',
      description: json["description"] ?? '',
      price: (json["price"] ?? 0).toDouble(),
      image: json["image"] ?? '',
      stock: json["stock"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "ID": id,
    "CreatedAt": createdAt.toIso8601String(),
    "UpdatedAt": updatedAt.toIso8601String(),
    "DeletedAt": deletedAt,
    "name": name,
    "description": description,
    "price": price,
    "image": image,
    "stock": stock,
  };
}
