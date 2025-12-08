import 'package:dio/dio.dart';
import 'package:myapp/domain/products.dart';

class ProductosRepository {
  Future<Product> getProductById(int id) async {
    final products = await Dio().get(
      'http://lcdp-backend-fntnnl-5acfdf-84-54-23-243.traefik.me/api/v1/products/get/$id',
    );
    return Product.fromJson(products.data);
  }

  Future<void> updateProduct(Product product) async {
    await Dio().put(
      'http://lcdp-backend-fntnnl-5acfdf-84-54-23-243.traefik.me/api/v1/products/update/${product.id}',
      data: product.toJson(),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
  }

  Future<void> deleteProduct(int id) async {
    await Dio().delete(
      'http://lcdp-backend-fntnnl-5acfdf-84-54-23-243.traefik.me/api/v1/products/delete/$id',
    );
  }

  Future<void> createProduct(Product product) async {
    await Dio().post(
      'http://lcdp-backend-fntnnl-5acfdf-84-54-23-243.traefik.me/api/v1/products/create',
      data: product.toJson(),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
  }
}
