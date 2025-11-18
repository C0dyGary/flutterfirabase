import 'package:flutter/material.dart';
import 'package:myapp/domain/app_colors.dart';
import 'package:myapp/domain/order.dart';
import 'package:myapp/domain/products.dart';
import 'package:myapp/repository/repository.dart';
import 'package:myapp/screens/providers/cart_provider.dart';
import 'package:myapp/screens/providers/order_provider.dart';
import 'package:provider/provider.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  Repository repository = Repository();
  ListProducts? listProducts;

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  Future<void> getProducts() async {
    listProducts = await repository.getProducts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final orderProvider = context.watch<OrderProvider>();
    const int quantity = 1;

    void addToOrderDetails(Product product) {
      setState(() {
        orderProvider.addOrderDetail(
          OrderDetail(productId: product.id, quantity: quantity),
        );
      });
    }

    return Container(
      color: Colors.white,
      child: RefreshIndicator(
        color: AppColor.primary,
        onRefresh: getProducts,
        child: listProducts == null
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: listProducts?.products.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Dismissible(
                      key: Key(listProducts!.products[index].id.toString()),
                      background: Container(
                        color: Colors.green,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20),
                        child: const Icon(
                          Icons.add_shopping_cart,
                          color: Colors.white,
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        // Agregar al carrito
                        cartProvider.addToCart(listProducts!.products[index]);
                        addToOrderDetails(listProducts!.products[index]);
                        // Mostrar mensaje
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppContessa.contessa900,
                            content: Text(
                              '${listProducts!.products[index].name} agregado al carrito',
                              style: TextStyle(color: Colors.white),
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                        // Retornar false para que NO se elimine el item
                        return false;
                      },
                      child: Container(
                        color: AppContessa.contessa200,
                        child: ListTile(
                          title: Text(
                            camelToSentence(listProducts!.products[index].name),
                            style: TextStyle(
                              color: AppContessa.contessa950,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            listProducts!.products[index].description,
                            style: TextStyle(
                              color: AppContessa.contessa800,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                          leading: Icon(
                            Icons.coffee,
                            color: AppContessa.contessa700,
                          ),
                          trailing: Text(
                            '${listProducts!.products[index].price.toString()} Bs',
                            style: TextStyle(
                              color: AppContessa.contessa950,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          onTap: () {
                            cartProvider.addToCart(
                              listProducts!.products[index],
                            );
                            addToOrderDetails(listProducts!.products[index]);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: AppContessa.contessa900,
                                content: Text(
                                  '${listProducts!.products[index].name} agregado al carrito',
                                  style: TextStyle(
                                    color: AppContessa.contessa50,
                                  ),
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

String camelToSentence(String text) {
  var result = text.replaceAll(RegExp(r'(?<!^)(?=[A-Z])'), r" ");
  var finalResult = result[0].toUpperCase() + result.substring(1);
  return finalResult;
}
