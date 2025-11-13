import 'package:flutter/material.dart';
import 'package:myapp/domain/app_colors.dart';
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
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Dismissible(
                  key: Key(cartProvider.cart[index].id.toString()),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    // Eliminar del carrito
                    cartProvider.removeFromCart(cartProvider.cart[index]);
                    return true;
                  },
                  child: Container(
                    color: AppContessa.contessa200,
                    child: ListTile(
                      title: Text(
                        camelToSentence(cartProvider.cart[index].name),
                        style: TextStyle(
                          color: AppContessa.contessa950,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '\$${cartProvider.cart[index].price.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: AppContessa.contessa700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ),
                ),
              );
            },
          );
  }
}

String camelToSentence(String text) {
  var result = text.replaceAll(RegExp(r'(?<!^)(?=[A-Z])'), r" ");
  var finalResult = result[0].toUpperCase() + result.substring(1);
  return finalResult;
}
