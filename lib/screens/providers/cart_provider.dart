import 'package:flutter/material.dart';
import 'package:myapp/domain/products.dart';

class CartProvider extends ChangeNotifier {
  List<Product> _cart = [];

  List<Product> get cart => _cart;

  //add
  void addToCart(Product product) {
    _cart.add(product);
    notifyListeners();
  }
}
