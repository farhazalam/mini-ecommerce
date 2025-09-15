import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mini_ecommerce/pages/products_page.dart';
import 'package:mini_ecommerce/pages/splash_page.dart';
import 'package:mini_ecommerce/pages/checkout_page.dart';
import 'package:mini_ecommerce/pages/orders_page.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/orders_provider.dart';
import 'services/payment_service.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize services
  await PaymentService.initialize();
  await NotificationService.initialize();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => OrdersProvider()),
      ],
      child: MaterialApp(
        title: 'Mini E-commerce',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: const SplashPage(),
        debugShowCheckedModeBanner: false,
        routes: {
          '/checkout': (context) => const CheckoutPage(),
          '/orders': (context) => const OrdersPage(),
          '/products': (context) => const ProductsPage(),
        },
      ),
    );
  }
}
