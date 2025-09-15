import 'product_model.dart';

class CartItemModel {
  final String productId;
  final ProductModel product;
  final int quantity;

  CartItemModel({
    required this.productId,
    required this.product,
    required this.quantity,
  });

  CartItemModel copyWith({
    String? productId,
    ProductModel? product,
    int? quantity,
  }) {
    return CartItemModel(
      productId: productId ?? this.productId,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  // Helper methods
  double get totalPrice => (product.slp * quantity).toDouble();
  String get formattedTotalPrice => 'AED ${totalPrice.toStringAsFixed(0)}';

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'quantity': quantity,
      'product': product.toMap(), // Include full product details
    };
  }

  factory CartItemModel.fromMap(
    Map<String, dynamic> map,
    ProductModel product,
  ) {
    return CartItemModel(
      productId: map['productId'] ?? '',
      product: product,
      quantity: map['quantity'] ?? 1,
    );
  }

  // New factory method for loading from Firestore with only productId and quantity
  factory CartItemModel.fromFirestoreMap(Map<String, dynamic> map) {
    final productId = map['productId']?.toString() ?? '';
    if (productId.isEmpty) {
      throw Exception('Product ID is empty');
    }

    final quantity = map['quantity'];
    final quantityInt = quantity is int
        ? quantity
        : (quantity is double ? quantity.toInt() : 1);

    // Create a placeholder product - this will be replaced when the actual product is fetched
    // This is a temporary solution until we can fetch the full product data
    final placeholderProduct = ProductModel(
      id: productId,
      name: 'Loading...',
      description: 'Product details loading...',
      image: '',
      mrp: 0,
      slp: 0,
      quantity: 0,
      type: 'Unknown',
    );

    return CartItemModel(
      productId: productId,
      product: placeholderProduct,
      quantity: quantityInt,
    );
  }
}
