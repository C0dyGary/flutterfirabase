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

  Future<List<Data>> listOrders() async {
    const url =
        'http://lcdp-backend-fntnnl-5acfdf-84-54-23-243.traefik.me/api/v1/orders/list';

    final response = await Dio().get(url);

    List<dynamic> ordersData;

    if (response.data is Map && response.data.containsKey('Data')) {
      ordersData = response.data['Data'] as List<dynamic>;
    } else if (response.data is List) {
      ordersData = response.data as List<dynamic>;
    } else {
      throw Exception(
        'Formato de respuesta inesperado: ${response.data.runtimeType}',
      );
    }

    final orders = <Data>[];

    for (var item in ordersData) {
      if (item == null || item is! Map) {
        continue;
      }

      try {
        final orderData = Data.fromJson(item as Map<String, dynamic>);
        orders.add(orderData);
      } catch (e) {
        continue;
      }
    }

    return orders;
  }

  Future<List<Data>> listOrdersByDate(DateTime date) async {
    final searchDate = DateTime(date.year, date.month, date.day);
    final allOrders = await listOrders();

    final filteredOrders = allOrders.where((order) {
      final orderDateUtc = order.createdAt;
      final orderDateLocal = orderDateUtc.toLocal();
      final orderDateNormalized = DateTime(
        orderDateLocal.year,
        orderDateLocal.month,
        orderDateLocal.day,
      );

      return orderDateNormalized.year == searchDate.year &&
          orderDateNormalized.month == searchDate.month &&
          orderDateNormalized.day == searchDate.day;
    }).toList();

    return filteredOrders;
  }
}
