import 'package:flutter/foundation.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItemModel> _items = {};

  Map<String, CartItemModel> get items => Map.unmodifiable(_items);

  List<CartItemModel> get cartItems => _items.values.toList();

  int get itemCount => _items.length;

  int get totalItems =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);

  String get formattedTotalPrice => 'AED ${totalPrice.toStringAsFixed(0)}';

  bool get isEmpty => _items.isEmpty;

  bool get isNotEmpty => _items.isNotEmpty;

  // Add item to cart
  void addItem(ProductModel product, {int quantity = 1}) {
    if (_items.containsKey(product.id)) {
      // Update existing item
      final existingItem = _items[product.id]!;
      final newQuantity = existingItem.quantity + quantity;

      if (newQuantity <= product.quantity) {
        _items[product.id] = existingItem.copyWith(quantity: newQuantity);
      } else {
        // Cannot add more than available stock
        return;
      }
    } else {
      // Add new item
      if (quantity <= product.quantity) {
        _items[product.id] = CartItemModel(
          productId: product.id,
          product: product,
          quantity: quantity,
        );
      } else {
        // Cannot add more than available stock
        return;
      }
    }
    notifyListeners();
  }

  // Remove item from cart
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  // Update item quantity
  void updateQuantity(String productId, int quantity) {
    if (_items.containsKey(productId)) {
      final item = _items[productId]!;

      if (quantity <= 0) {
        removeItem(productId);
      } else if (quantity <= item.product.quantity) {
        _items[productId] = item.copyWith(quantity: quantity);
        notifyListeners();
      }
    }
  }

  // Clear entire cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // Check if product is in cart
  bool isInCart(String productId) {
    return _items.containsKey(productId);
  }

  // Get quantity of specific product in cart
  int getQuantity(String productId) {
    return _items[productId]?.quantity ?? 0;
  }

  // Get cart item by product ID
  CartItemModel? getCartItem(String productId) {
    return _items[productId];
  }
}
