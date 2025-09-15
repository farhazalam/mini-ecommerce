import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';
import 'products_service.dart';

class PaymentService {
  // Replace these with your actual sandbox keys
  static const String _publishableKey =
      'pk_test_51S7XAARzy6xzTn9aZFkVnWMZEaPxDc7BZaP2oTUdyQ13U2xxZnKYhAWAbg0F3hDpG9onJKpeNdS6aWJfzE456QXe003S82f7nc'; // Your publishable key
  static const String _secretKey =
      'sk_test_51S7XAARzy6xzTn9aGsapksNLPGGsL6xSWUE4pUwSyji2OF9m8p1SHZlfhyAfQU79vCYcMtwA7UlnkJR2CcaytCM0001svHbto6'; // Your secret key

  static Future<void> initialize() async {
    Stripe.publishableKey = _publishableKey;
    await Stripe.instance.applySettings();
  }

  // Method to check if Apple Pay is available and properly configured
  static Future<bool> isApplePayAvailable() async {
    try {
      // Check if Apple Pay is supported on the current platform
      return await Stripe.instance.isPlatformPaySupported();
    } catch (e) {
      return false;
    }
  }

  // Method to get Apple Pay configuration (call this when you have merchant identifier)
  static PaymentSheetApplePay? getApplePayConfig() {
    // Uncomment and configure when you have a merchant identifier
    // return const PaymentSheetApplePay(
    //   merchantCountryCode: 'AE',
    //   merchantIdentifier: 'your_merchant_identifier_here',
    // );
    return null; // Disabled for now
  }

  // Method to validate payment intent before processing
  static Future<bool> validatePaymentIntent(String clientSecret) async {
    try {
      // Basic validation - check if client secret is not empty
      if (clientSecret.isEmpty) {
        return false;
      }

      // You can add more validation here if needed
      // For example, checking if the payment intent is still valid
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>> createPaymentIntent({
    required double amount,
    required String currency,
    required String orderId,
  }) async {
    try {
      // Create payment intent using Stripe API directly (for testing only)
      final response = await _makeStripeRequest(
        'https://api.stripe.com/v1/payment_intents',
        {
          'amount': (amount * 100).toInt(), // Convert to cents
          'currency': currency.toLowerCase(),
          'metadata[orderId]': orderId,
          'automatic_payment_methods[enabled]': 'true',
        },
      );

      return {
        'id': response['id'],
        'client_secret': response['client_secret'],
        'status': response['status'],
      };
    } catch (e) {
      throw Exception('Failed to create payment intent: $e');
    }
  }

  static Future<bool> confirmPayment({
    required String paymentIntentId,
    required String clientSecret,
  }) async {
    try {
      // Validate payment intent before processing
      if (!await validatePaymentIntent(clientSecret)) {
        throw Exception('Invalid payment intent');
      }

      // Use Stripe Payment Sheet for payment confirmation
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Mini E-commerce',
          // Use Apple Pay configuration method
          applePay: getApplePayConfig(),
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'AE',
            testEnv: true, // Set to false for production
          ),
          // Enable customer creation for better payment experience
          customerId: null, // You can add customer ID if you have one
          customerEphemeralKeySecret:
              null, // You can add this if you have customer management
        ),
      );

      // Present the payment sheet
      await Stripe.instance.presentPaymentSheet();

      // If we reach here, payment was successful
      return true;
    } catch (e) {
      if (e is StripeException) {
        // Handle Stripe-specific errors
        if (e.error.code == FailureCode.Canceled) {
          throw Exception('Payment was canceled by user');
        } else if (e.error.code == FailureCode.Failed) {
          throw Exception('Payment failed: ${e.error.message}');
        } else {
          throw Exception('Payment error: ${e.error.message}');
        }
      } else {
        throw Exception('Payment confirmation failed: $e');
      }
    }
  }

  // Helper method to make Stripe API requests
  static Future<Map<String, dynamic>> _makeStripeRequest(
    String url,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $_secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: data.map((key, value) => MapEntry(key, value.toString())),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorBody = jsonDecode(response.body);
        final errorMessage = errorBody['error']?['message'] ?? 'Unknown error';
        throw Exception(
          'Stripe API Error ($response.statusCode): $errorMessage',
        );
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      } else {
        throw Exception('Network error: $e');
      }
    }
  }

  static Future<OrderModel> createOrder({
    required List<CartItemModel> items,
    required double totalAmount,
    required String paymentIntentId,
    String? shippingAddress,
    String? notes,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final orderId = DateTime.now().millisecondsSinceEpoch.toString();
      final deliveryFee = 0.0; // Free delivery for now
      final finalAmount = totalAmount + deliveryFee;

      final order = OrderModel(
        id: orderId,
        userId: user.uid,
        items: items,
        totalAmount: totalAmount,
        deliveryFee: deliveryFee,
        finalAmount: finalAmount,
        status: OrderStatus.confirmed,
        createdAt: DateTime.now(),
        paymentIntentId: paymentIntentId,
        shippingAddress: shippingAddress,
        notes: notes,
      );

      // Save order to Firestore with proper data structure
      final orderData = order.toMap();
      print('Saving order to Firestore: $orderData'); // Debug log

      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .set(orderData);

      print('Order saved successfully with ID: $orderId'); // Debug log

      return order;
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  static Future<List<OrderModel>> getUserOrders() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Query without orderBy to avoid composite index requirement
      // We'll sort the results in memory instead
      print('Fetching orders for user: ${user.uid}'); // Debug log

      final snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: user.uid)
          .get();

      print('Found ${snapshot.docs.length} orders in Firestore'); // Debug log
      final orders = <OrderModel>[];

      for (final doc in snapshot.docs) {
        try {
          final data = doc.data();
          print('Processing order document: ${doc.id}'); // Debug log
          print('Document data: $data'); // Debug log

          // Check if items data exists and is not null
          final itemsData = data['items'];
          if (itemsData == null) {
            print('Warning: Order ${doc.id} has no items data, skipping');
            continue;
          }

          if (itemsData is! List) {
            print(
              'Warning: Order ${doc.id} items data is not a list, skipping',
            );
            continue;
          }

          // Convert items data back to CartItemModel
          final items = <CartItemModel>[];
          final productsService = ProductsService();

          for (final itemData in itemsData) {
            try {
              if (itemData == null) {
                print('Warning: Null item data found, skipping');
                continue;
              }

              if (itemData is! Map<String, dynamic>) {
                print('Warning: Item data is not a Map, skipping');
                continue;
              }

              // Get productId and quantity
              final productId = itemData['productId']?.toString() ?? '';
              final quantity = itemData['quantity'];
              final quantityInt = quantity is int
                  ? quantity
                  : (quantity is double ? quantity.toInt() : 1);

              if (productId.isEmpty) {
                print('Warning: Product ID is empty, skipping item');
                continue;
              }

              // Fetch the actual product data
              final product = await productsService.getProductById(productId);
              if (product == null) {
                print(
                  'Warning: Product with ID $productId not found, skipping item',
                );
                continue;
              }

              // Create CartItemModel with actual product data
              items.add(
                CartItemModel(
                  productId: productId,
                  product: product,
                  quantity: quantityInt,
                ),
              );
            } catch (e) {
              print('Error processing item: $e');
              continue;
            }
          }

          if (items.isNotEmpty) {
            try {
              orders.add(OrderModel.fromMap(data, items));
              print(
                'Successfully processed order ${doc.id} with ${items.length} items',
              );
            } catch (e) {
              print('Error creating OrderModel for ${doc.id}: $e');
              // Create a minimal valid order as fallback
              final fallbackOrder = OrderModel(
                id: doc.id,
                userId: data['userId']?.toString() ?? 'unknown',
                items: items,
                totalAmount: (data['totalAmount'] ?? 0.0).toDouble(),
                deliveryFee: (data['deliveryFee'] ?? 0.0).toDouble(),
                finalAmount: (data['finalAmount'] ?? 0.0).toDouble(),
                status: OrderStatus.values.firstWhere(
                  (e) => e.name == data['status'],
                  orElse: () => OrderStatus.pending,
                ),
                createdAt: data['createdAt'] != null
                    ? DateTime.fromMillisecondsSinceEpoch(data['createdAt'])
                    : DateTime.now(),
                paymentIntentId: data['paymentIntentId']?.toString(),
                shippingAddress: data['shippingAddress']?.toString(),
                notes: data['notes']?.toString(),
              );
              orders.add(fallbackOrder);
              print('Created fallback order for ${doc.id}');
            }
          } else {
            print('Warning: Order ${doc.id} has no valid items, skipping');
          }
        } catch (e) {
          print('Error processing order document ${doc.id}: $e');
          continue;
        }
      }

      // Sort by createdAt in descending order (newest first)
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      print('Final orders count: ${orders.length}'); // Debug log
      for (final order in orders) {
        print(
          'Order ${order.id}: ${order.items.length} items, status: ${order.status.name}',
        ); // Debug log
      }

      return orders;
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  static Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update(
        {
          'status': status.name,
          'updatedAt': DateTime.now().millisecondsSinceEpoch,
        },
      );
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  // Debug method to check order data structure
  static Future<void> debugOrderData(String orderId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .get();

      if (doc.exists) {
        print('Order $orderId data: ${doc.data()}');
      } else {
        print('Order $orderId does not exist');
      }
    } catch (e) {
      print('Error debugging order $orderId: $e');
    }
  }

  // Method to delete corrupted orders (use with caution)
  static Future<void> deleteCorruptedOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .delete();
      print('Deleted corrupted order: $orderId');
    } catch (e) {
      print('Error deleting order $orderId: $e');
    }
  }
}
