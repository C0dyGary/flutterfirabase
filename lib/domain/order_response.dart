// To parse this JSON data, do
//
//     final orderResponse = orderResponseFromJson(jsonString);

import 'dart:convert';

OrderResponse orderResponseFromJson(String str) =>
    OrderResponse.fromJson(json.decode(str));

String orderResponseToJson(OrderResponse data) => json.encode(data.toJson());

class OrderResponse {
  final Data data;
  final String message;

  OrderResponse({required this.data, required this.message});

  factory OrderResponse.fromJson(Map<String, dynamic> json) => OrderResponse(
    data: Data.fromJson(json["Data"]),
    message: json["Message"],
  );

  Map<String, dynamic> toJson() => {"Data": data.toJson(), "Message": message};
}

class Data {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;
  final String name;
  final List<OrderDetail> orderDetails;
  final double totalPrice;
  final String status;
  final String paymentMethod;

  Data({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.name,
    required this.orderDetails,
    required this.totalPrice,
    required this.status,
    required this.paymentMethod,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["ID"],
    createdAt: DateTime.parse(json["CreatedAt"]),
    updatedAt: DateTime.parse(json["UpdatedAt"]),
    deletedAt: json["DeletedAt"],
    name: json["name"],
    orderDetails: List<OrderDetail>.from(
      json["order_details"].map((x) => OrderDetail.fromJson(x)),
    ),
    totalPrice: json["total_price"]?.toDouble(),
    status: json["status"],
    paymentMethod: json["payment_method"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "CreatedAt": createdAt.toIso8601String(),
    "UpdatedAt": updatedAt.toIso8601String(),
    "DeletedAt": deletedAt,
    "name": name,
    "order_details": List<dynamic>.from(orderDetails.map((x) => x.toJson())),
    "total_price": totalPrice,
    "status": status,
    "payment_method": paymentMethod,
  };
}

class OrderDetail {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;
  final int orderId;
  final int productId;
  final Product product;
  final int quantity;
  final double totalPrice;

  OrderDetail({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.orderId,
    required this.productId,
    required this.product,
    required this.quantity,
    required this.totalPrice,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
    id: json["ID"],
    createdAt: DateTime.parse(json["CreatedAt"]),
    updatedAt: DateTime.parse(json["UpdatedAt"]),
    deletedAt: json["DeletedAt"],
    orderId: json["order_id"],
    productId: json["product_id"],
    product: Product.fromJson(json["product"]),
    quantity: json["quantity"],
    totalPrice: json["total_price"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "CreatedAt": createdAt.toIso8601String(),
    "UpdatedAt": updatedAt.toIso8601String(),
    "DeletedAt": deletedAt,
    "order_id": orderId,
    "product_id": productId,
    "product": product.toJson(),
    "quantity": quantity,
    "total_price": totalPrice,
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

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["ID"],
    createdAt: DateTime.parse(json["CreatedAt"]),
    updatedAt: DateTime.parse(json["UpdatedAt"]),
    deletedAt: json["DeletedAt"],
    name: json["name"],
    description: json["description"],
    price: json["price"]?.toDouble(),
    image: json["image"],
    stock: json["stock"],
  );

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
