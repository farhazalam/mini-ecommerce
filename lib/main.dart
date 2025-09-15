import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mini_ecommerce/pages/products_page.dart';
import 'package:mini_ecommerce/pages/splash_page.dart';
import 'package:mini_ecommerce/pages/checkout_page.dart';
import 'package:mini_ecommerce/pages/orders_page.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/orders_provider.dart';
import 'providers/language_provider.dart';
import 'services/payment_service.dart';
import 'services/notification_service.dart';
import 'package:mini_ecommerce/l10n/app_localizations.dart';

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
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: 'Mini E-commerce',
            theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
            home: const SplashPage(),
            debugShowCheckedModeBanner: false,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English
              Locale('ar', ''), // Arabic
            ],
            locale: languageProvider.currentLocale,
            routes: {
              '/checkout': (context) => const CheckoutPage(),
              '/orders': (context) => const OrdersPage(),
              '/products': (context) => const ProductsPage(),
            },
          );
        },
      ),
    );
  }
}
