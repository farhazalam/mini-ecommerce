import 'cart_item_model.dart';

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
}

class OrderModel {
  final String id;
  final String userId;
  final List<CartItemModel> items;
  final double totalAmount;
  final double deliveryFee;
  final double finalAmount;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? paymentIntentId;
  final String? shippingAddress;
  final String? notes;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    this.deliveryFee = 0.0,
    required this.finalAmount,
    this.status = OrderStatus.pending,
    required this.createdAt,
    this.updatedAt,
    this.paymentIntentId,
    this.shippingAddress,
    this.notes,
  });

  OrderModel copyWith({
    String? id,
    String? userId,
    List<CartItemModel>? items,
    double? totalAmount,
    double? deliveryFee,
    double? finalAmount,
    OrderStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? paymentIntentId,
    String? shippingAddress,
    String? notes,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      finalAmount: finalAmount ?? this.finalAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      paymentIntentId: paymentIntentId ?? this.paymentIntentId,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      notes: notes ?? this.notes,
    );
  }

  // Helper methods
  String get formattedTotalAmount => 'AED ${totalAmount.toStringAsFixed(0)}';
  String get formattedFinalAmount => 'AED ${finalAmount.toStringAsFixed(0)}';
  String get formattedDeliveryFee => 'AED ${deliveryFee.toStringAsFixed(0)}';

  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get statusDescription {
    switch (status) {
      case OrderStatus.pending:
        return 'Your order is being processed';
      case OrderStatus.confirmed:
        return 'Your order has been confirmed';
      case OrderStatus.processing:
        return 'Your order is being prepared';
      case OrderStatus.shipped:
        return 'Your order is on the way';
      case OrderStatus.delivered:
        return 'Your order has been delivered';
      case OrderStatus.cancelled:
        return 'Your order has been cancelled';
    }
  }

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'deliveryFee': deliveryFee,
      'finalAmount': finalAmount,
      'status': status.name,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'paymentIntentId': paymentIntentId,
      'shippingAddress': shippingAddress,
      'notes': notes,
    };
  }

  factory OrderModel.fromMap(
    Map<String, dynamic> map,
    List<CartItemModel> items,
  ) {
    return OrderModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      items: items,
      totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
      deliveryFee: (map['deliveryFee'] ?? 0.0).toDouble(),
      finalAmount: (map['finalAmount'] ?? 0.0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => OrderStatus.pending,
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'])
          : null,
      paymentIntentId: map['paymentIntentId'],
      shippingAddress: map['shippingAddress'],
      notes: map['notes'],
    );
  }
}
