import 'package:flutter/material.dart';
import 'package:myapp/domain/app_colors.dart';
import 'package:myapp/screens/providers/cart_provider.dart';
import 'package:myapp/screens/providers/order_provider.dart';
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
    final orderProvider = context.watch<OrderProvider>();
    print('Cart length: ${orderProvider.currentOrder.orderDetails.length}');

    return cartProvider.cart.isEmpty
        ? const Center(child: Text('No hay productos en el carrito'))
        : ListView.builder(
            itemCount: cartProvider.cart.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Dismissible(
                  key: Key(cartProvider.cart[index].product.id.toString()),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    // Eliminar del carrito
                    cartProvider.removeFromCart(
                      cartProvider.cart[index].product,
                    );
                    orderProvider.removeOrderDetail(
                      orderProvider.currentOrder.orderDetails[index],
                    );
                    return true;
                  },
                  child: Container(
                    color: AppContessa.contessa200,
                    child: ListTile(
                      title: Text(
                        "${orderProvider.currentOrder.orderDetails[index].quantity}x ${camelToSentence(cartProvider.cart[index].product.name)}",
                        style: TextStyle(
                          color: AppContessa.contessa950,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                            '${cartProvider.cart[index].product.price.toStringAsFixed(2)} Bs',
                            style: TextStyle(
                              color: AppContessa.contessa700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '  -  ${cartProvider.cart[index].totalPrice.toStringAsFixed(2)} Bs total',
                            style: TextStyle(
                              color: AppContessa.contessa700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //add buttons to increase and decrease quantity
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    if (orderProvider
                                            .currentOrder
                                            .orderDetails[index]
                                            .quantity >
                                        1) {
                                      orderProvider
                                          .currentOrder
                                          .orderDetails[index]
                                          .quantity--;
                                      cartProvider.cart[index]
                                          .decrementQuantity();
                                      cartProvider.calculateTotalPrice();
                                    }
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    orderProvider
                                        .currentOrder
                                        .orderDetails[index]
                                        .quantity++;
                                    cartProvider.cart[index]
                                        .incrementQuantity();
                                    cartProvider.calculateTotalPrice();
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
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
