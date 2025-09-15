import 'package:flutter/foundation.dart';
import '../models/order_model.dart';
import '../services/payment_service.dart';

class OrdersProvider with ChangeNotifier {
  List<OrderModel> _orders = [];
  bool _isLoading = false;
  String? _error;

  List<OrderModel> get orders => List.unmodifiable(_orders);
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get orders by status
  List<OrderModel> getOrdersByStatus(OrderStatus status) {
    return _orders.where((order) => order.status == status).toList();
  }

  // Get pending orders
  List<OrderModel> get pendingOrders => getOrdersByStatus(OrderStatus.pending);

  // Get confirmed orders
  List<OrderModel> get confirmedOrders =>
      getOrdersByStatus(OrderStatus.confirmed);

  // Get processing orders
  List<OrderModel> get processingOrders =>
      getOrdersByStatus(OrderStatus.processing);

  // Get shipped orders
  List<OrderModel> get shippedOrders => getOrdersByStatus(OrderStatus.shipped);

  // Get delivered orders
  List<OrderModel> get deliveredOrders =>
      getOrdersByStatus(OrderStatus.delivered);

  // Get cancelled orders
  List<OrderModel> get cancelledOrders =>
      getOrdersByStatus(OrderStatus.cancelled);

  // Load user orders
  Future<void> loadOrders() async {
    _setLoading(true);
    _clearError();

    try {
      print('OrdersProvider: Loading orders...'); // Debug log
      _orders = await PaymentService.getUserOrders();
      print('OrdersProvider: Received ${_orders.length} orders'); // Debug log
      notifyListeners();
      print('OrdersProvider: Notified listeners'); // Debug log
    } catch (e) {
      print('OrdersProvider: Error loading orders: $e'); // Debug log
      _setError('Failed to load orders: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Add new order
  void addOrder(OrderModel order) {
    _orders.insert(0, order); // Add to beginning of list
    notifyListeners();
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      await PaymentService.updateOrderStatus(orderId: orderId, status: status);

      // Update local order
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        _orders[index] = _orders[index].copyWith(
          status: status,
          updatedAt: DateTime.now(),
        );
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to update order status: $e');
    }
  }

  // Get order by ID
  OrderModel? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  // Get total orders count
  int get totalOrders => _orders.length;

  // Get orders count by status
  int getOrdersCountByStatus(OrderStatus status) {
    return _orders.where((order) => order.status == status).length;
  }

  // Get total amount spent
  double get totalAmountSpent {
    return _orders
        .where((order) => order.status != OrderStatus.cancelled)
        .fold(0.0, (sum, order) => sum + order.finalAmount);
  }

  // Get formatted total amount spent
  String get formattedTotalAmountSpent =>
      'AED ${totalAmountSpent.toStringAsFixed(0)}';

  // Refresh orders
  Future<void> refreshOrders() async {
    await loadOrders();
  }

  // Clear all orders (useful for logout)
  void clearOrders() {
    _orders.clear();
    _clearError();
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
