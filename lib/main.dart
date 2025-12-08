import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:myapp/domain/order.dart';
import 'package:myapp/screens/home_page.dart';
import 'package:myapp/screens/login_paage.dart';
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
        title: 'Coffee House',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('es', ''), Locale('en', '')],
        locale: const Locale('es', ''),
        home: const HomePage(),
        routes: {
          '/pay': (context) => const PayPage(),
          '/home': (context) => const HomePage(),
          '/login': (context) => const MyLoginCoffeePage(),
        },
      ),
    );
  }
}
