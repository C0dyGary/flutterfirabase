import 'package:dio/dio.dart';
import 'package:myapp/domain/order.dart';
import 'package:myapp/domain/order_response.dart';
import 'package:myapp/domain/products.dart';

class Repository {
  Future<ListProducts> getProducts() async {
    final response = await Dio().get(
      'http://lcdp-backend-fntnnl-5acfdf-84-54-23-243.traefik.me/api/v1/products/list',
    );
    return ListProducts.fromJson(response.data);
  }

  Future<OrderResponse> createOrder(Order order) async {
    final response = await Dio().post(
      'http://lcdp-backend-fntnnl-5acfdf-84-54-23-243.traefik.me/api/v1/orders/create',
      data: orderToJson(order),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    return OrderResponse.fromJson(response.data);
  }

  Future<OrderResponse> getOrder(int orderId) async {
    final response = await Dio().get(
      'http://lcdp-backend-fntnnl-5acfdf-84-54-23-243.traefik.me/api/v1/orders/get/$orderId',
    );
    return OrderResponse.fromJson(response.data);
  }

  Future<List<OrderResponse>> listOrders() async {
    final response = await Dio().get(
      'http://lcdp-backend-fntnnl-5acfdf-84-54-23-243.traefik.me/api/v1/orders/list',
    );
    return List<OrderResponse>.from(
      response.data.map((x) => OrderResponse.fromJson(x)),
    );
  }
}
