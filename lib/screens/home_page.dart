import 'package:flutter/material.dart';
import 'package:myapp/domain/app_colors.dart';
import 'package:myapp/screens/providers/cart_provider.dart';
import 'package:myapp/screens/views/cart_view.dart';
import 'package:myapp/screens/views/modal_sheet_pay.dart';
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
        backgroundColor: AppContessa.contessa500,
        foregroundColor: Colors.white,
      ),

      body: IndexedStack(index: _selectedIndex, children: views),

      bottomNavigationBar: NavigationBar(
        elevation: 10,
        backgroundColor: AppContessa.contessa500,
        indicatorColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppContessa.contessa50,
          ),
        ),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.coffee, color: AppContessa.contessa50),
            selectedIcon: Icon(Icons.coffee, color: AppContessa.contessa950),
            label: 'Cafes',
          ),
          NavigationDestination(
            selectedIcon: Badge(
              label: Text('${cartProvider.cart.length}'),
              child: Icon(Icons.shopping_cart, color: AppContessa.contessa950),
            ),
            icon: Badge(
              label: Text('${cartProvider.cart.length}'),
              child: Icon(Icons.shopping_cart, color: AppContessa.contessa50),
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
      floatingActionButton: _selectedIndex == 0
          ? null
          : FloatingActionButton(
              backgroundColor: AppContessa.contessa500,
              onPressed: () {
                showModalBottomSheet(
                  scrollControlDisabledMaxHeightRatio: 0.84536,
                  context: context,
                  builder: (BuildContext context) {
                    return Column(
                      children: [
                        Center(
                          child: Container(
                            height: 4,
                            width: 40,
                            margin: const EdgeInsets.only(top: 12, bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ModalSheetPay(
                              scrollController: ScrollController(),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Icon(Icons.payments, color: AppContessa.contessa50),
            ),
    );
  }
}
