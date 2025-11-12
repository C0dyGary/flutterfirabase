import 'package:flutter/material.dart';
import 'package:myapp/screens/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  Widget build(BuildContext context) {
    final CartProvider cartProvider = context.watch<CartProvider>();

    return cartProvider.cart.isEmpty
        ? const Center(child: Text('No hay productos en el carrito'))
        : ListView.builder(
            itemCount: cartProvider.cart.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(cartProvider.cart[index].name),
                leading: Icon(Icons.coffee),
                trailing: Text(
                  '${cartProvider.cart[index].price.toString()} Bs',
                ),
                onTap: () {
                  //cartProvider.removeFromCart(cartProvider.cart[index]);
                },
              );
            },
          );
  }
}
