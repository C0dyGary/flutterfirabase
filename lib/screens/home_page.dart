import 'package:flutter/material.dart';
import 'package:myapp/screens/providers/cart_provider.dart';
import 'package:myapp/screens/views/cart_view.dart';
import 'package:myapp/screens/views/products_view.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final views = [const ProductsView(), const CartView()];
  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Coffee"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      body: IndexedStack(index: _selectedIndex, children: views),

      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.deepPurple,
        destinations: [
          NavigationDestination(icon: Icon(Icons.coffee), label: 'Cafes'),
          NavigationDestination(
            icon: Badge(
              label: Text('${cartProvider.cart.length}'),
              child: Icon(Icons.shopping_cart),
            ),
            label: 'Cart',
          ),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
