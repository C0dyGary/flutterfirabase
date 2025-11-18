import 'package:flutter/material.dart';
import 'package:myapp/domain/order.dart';
import 'package:myapp/screens/home_page.dart';
import 'package:myapp/screens/pay_page.dart';
import 'package:myapp/screens/providers/cart_provider.dart';
import 'package:myapp/screens/providers/order_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(
          create: (_) => OrderProvider(
            // Initial empty order
            Order(name: '', status: '', paymentMethod: '', orderDetails: []),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Coffee Shop',
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
        routes: {
          '/pay': (context) => const PayPage(),
          '/home': (context) => const HomePage(),
        },
      ),
    );
  }
}
