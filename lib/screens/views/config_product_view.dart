import 'package:flutter/material.dart';
import 'package:myapp/domain/products.dart';
import 'package:myapp/repository/repository.dart';
import 'package:myapp/screens/views/modal_edit_product.dart';

class ConfigProductView extends StatefulWidget {
  const ConfigProductView({super.key});

  @override
  State<ConfigProductView> createState() => _ConfigproductViewState();
}

class _ConfigproductViewState extends State<ConfigProductView> {
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
    return Container(
      color: Colors.white,
      child: RefreshIndicator(
        color: Colors.brown,
        onRefresh: getProducts,
        child: listProducts == null
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: listProducts?.products.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(listProducts!.products[index].name),
                    leading: Icon(Icons.coffee),
                    subtitle: Text(
                      '\$${listProducts!.products[index].price.toStringAsFixed(2)}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        // Acción para editar el producto
                        final result = await showModalBottomSheet(
                          context: context,
                          scrollControlDisabledMaxHeightRatio: 0.6,
                          builder: (BuildContext context) {
                            return Column(
                              children: [
                                Center(
                                  child: Container(
                                    height: 4,
                                    width: 40,
                                    margin: const EdgeInsets.only(
                                      top: 12,
                                      bottom: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ModalEditProduct(
                                      scrollController: ScrollController(),
                                      product: listProducts!.products[index],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );

                        // Si el modal retorna true, recargar productos
                        if (result == true) {
                          await getProducts();
                        }
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
