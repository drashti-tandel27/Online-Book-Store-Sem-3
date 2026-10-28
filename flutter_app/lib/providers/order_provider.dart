import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/order_service.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _orderService = OrderService();

  List<Order> _orders = [];
  Order? _activeOrder;
  bool _isLoadingOrders = false;
  bool _isLoadingDetails = false;
  bool _isPlacingOrder = false;
  bool _isCancelling = false;
  String? _errorMessage;

  List<Order> get orders => _orders;
  Order? get activeOrder => _activeOrder;
  bool get isLoadingOrders => _isLoadingOrders;
  bool get isLoadingDetails => _isLoadingDetails;
  bool get isPlacingOrder => _isPlacingOrder;
  bool get isCancelling => _isCancelling;
  String? get errorMessage => _errorMessage;

  // Fetch Order History
  Future<void> fetchOrders() async {
    _isLoadingOrders = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _orders = await _orderService.getOrders();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoadingOrders = false;
      notifyListeners();
    }
  }

  // Fetch Single Order Details
  Future<void> fetchOrderDetails(int orderId) async {
    _isLoadingDetails = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _activeOrder = await _orderService.getOrderDetails(orderId);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoadingDetails = false;
      notifyListeners();
    }
  }

  // Place Order
  Future<Order?> placeOrder({
    required String shippingAddress,
    required String paymentMethod,
    String? recipientName,
    String? recipientPhone,
    String? notes,
    List<Map<String, dynamic>>? items,
  }) async {
    _isPlacingOrder = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final placedOrder = await _orderService.placeOrder(
        shippingAddress: shippingAddress,
        paymentMethod: paymentMethod,
        recipientName: recipientName,
        recipientPhone: recipientPhone,
        notes: notes,
        items: items,
      );

      _orders.insert(0, placedOrder);
      _activeOrder = placedOrder;
      _isPlacingOrder = false;
      notifyListeners();
      return placedOrder;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isPlacingOrder = false;
      notifyListeners();
      return null;
    }
  }

  // Cancel Order
  Future<bool> cancelOrder(int orderId, {String? reason}) async {
    _isCancelling = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedOrder = await _orderService.cancelOrder(orderId, reason: reason);
      
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index >= 0) {
        _orders[index] = updatedOrder;
      }
      if (_activeOrder?.id == orderId) {
        _activeOrder = updatedOrder;
      }

      _isCancelling = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isCancelling = false;
      notifyListeners();
      return false;
    }
  }
}
