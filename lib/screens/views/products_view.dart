import 'package:flutter/material.dart';
import 'package:myapp/domain/products.dart';
import 'package:myapp/repository/repository.dart';
import 'package:myapp/screens/providers/cart_provider.dart';
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

    return Container(
      color: Colors.white,
      child: RefreshIndicator(
        onRefresh: getProducts,
        child: listProducts == null
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: listProducts?.products.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(listProducts!.products[index].name),
                    leading: Icon(Icons.coffee),
                    trailing: Text(
                      '${listProducts!.products[index].price.toString()} Bs',
                    ),
                    onTap: () {
                      cartProvider.addToCart(listProducts!.products[index]);
                      print('${cartProvider.cart.length}');
                      for (var element in cartProvider.cart) {
                        print('${element.id} ${element.name}');
                      }
                    },
                  );
                },
              ),
      ),
    );
  }
}
