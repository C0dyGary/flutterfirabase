import 'package:flutter/material.dart';
import 'package:myapp/domain/products.dart';

class CartProvider extends ChangeNotifier {
  final List<Item> _cart = [];

  List<Item> get cart => _cart;
  double totalPrice = 0.0;

  //add
  void addToCart(Product product) {
    _cart.add(Item(product: product));
    calculateTotalPrice();
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cart.remove(_cart.firstWhere((item) => item.product.id == product.id));
    calculateTotalPrice();
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    totalPrice = 0.0;
    notifyListeners();
  }

  void calculateTotalPrice() {
    totalPrice = 0.0;
    for (var item in _cart) {
      totalPrice += item.product.price * item.quantity;
    }
    notifyListeners();
  }
}

class Item {
  Product product;
  int quantity;
  double totalPrice;

  Item({required this.product, this.quantity = 1, double? totalPrice})
    : totalPrice = totalPrice ?? product.price * quantity;

  void incrementQuantity() {
    quantity++;
    totalPrice = product.price * quantity;
  }

  void decrementQuantity() {
    if (quantity > 1) {
      quantity--;
      totalPrice = product.price * quantity;
    }
  }
}
