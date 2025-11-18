// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  String name;
  String status;
  String paymentMethod;
  List<OrderDetail> orderDetails;

  Order({
    required this.name,
    required this.status,
    required this.paymentMethod,
    required this.orderDetails,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    name: json["name"],
    status: json["status"],
    paymentMethod: json["payment_method"],
    orderDetails: List<OrderDetail>.from(
      json["order_details"].map((x) => OrderDetail.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "status": status,
    "payment_method": paymentMethod,
    "order_details": List<dynamic>.from(orderDetails.map((x) => x.toJson())),
  };
}

class OrderDetail {
  final int productId;
  int quantity;

  OrderDetail({required this.productId, required this.quantity});

  factory OrderDetail.fromJson(Map<String, dynamic> json) =>
      OrderDetail(productId: json["product_id"], quantity: json["quantity"]);

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "quantity": quantity,
  };
}
