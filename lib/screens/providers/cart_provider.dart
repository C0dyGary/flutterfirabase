import 'package:flutter/material.dart';
import 'package:myapp/domain/products.dart';

class CartProvider extends ChangeNotifier {
  final List<Product> _cart = [];

  List<Product> get cart => _cart;

  //add
  void addToCart(Product product) {
    _cart.add(product);
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cart.remove(product);
    notifyListeners();
  }
}
