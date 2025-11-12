import 'package:dio/dio.dart';
import 'package:myapp/domain/products.dart';

class Repository {
  Future<ListProducts> getProducts() async {
    final response = await Dio().get(
      'http://lcdp-backend-fntnnl-5acfdf-84-54-23-243.traefik.me/api/v1/products/list',
    );
    print(response.data);
    return ListProducts.fromJson(response.data);
  }
}
