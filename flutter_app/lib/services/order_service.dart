import '../config/api_config.dart';
import '../models/order.dart';
import 'api_service.dart';

class OrderService {
  final ApiService _api = ApiService();

  // Get Order History
  Future<List<Order>> getOrders() async {
    final response = await _api.get(ApiConfig.orders);
    List<dynamic> list = [];

    if (response is List) {
      list = response;
    } else if (response is Map<String, dynamic>) {
      if (response['orders'] is List) {
        list = response['orders'];
      } else if (response['data'] is List) {
        list = response['data'];
      }
    }

    return list.map((item) => Order.fromJson(item as Map<String, dynamic>)).toList();
  }

  // Get Order Details
  Future<Order> getOrderDetails(int id) async {
    final response = await _api.get(ApiConfig.orderDetails(id));
    Map<String, dynamic> orderData = {};

    if (response is Map<String, dynamic>) {
      if (response['order'] is Map<String, dynamic>) {
        orderData = response['order'];
      } else if (response['data'] is Map<String, dynamic>) {
        orderData = response['data'];
      } else {
        orderData = response;
      }
    }

    return Order.fromJson(orderData);
  }

  // Place Order
  Future<Order> placeOrder({
    required String shippingAddress,
    required String paymentMethod,
    String? recipientName,
    String? recipientPhone,
    String? notes,
    List<Map<String, dynamic>>? items,
  }) async {
    final response = await _api.post(
      ApiConfig.placeOrder,
      body: {
        'shipping_address': shippingAddress.trim(),
        'payment_method': paymentMethod,
        if (recipientName != null && recipientName.isNotEmpty) 'recipient_name': recipientName.trim(),
        if (recipientPhone != null && recipientPhone.isNotEmpty) 'recipient_phone': recipientPhone.trim(),
        if (notes != null && notes.isNotEmpty) 'notes': notes.trim(),
        if (items != null && items.isNotEmpty) 'items': items,
      },
    );

    Map<String, dynamic> orderData = {};
    if (response is Map<String, dynamic>) {
      if (response['order'] is Map<String, dynamic>) {
        orderData = response['order'];
      } else if (response['data'] is Map<String, dynamic>) {
        orderData = response['data'];
      } else {
        orderData = response;
      }
    }

    return Order.fromJson(orderData);
  }

  // Cancel Order
  Future<Order> cancelOrder(int id, {String? reason}) async {
    final response = await _api.post(
      ApiConfig.cancelOrder(id),
      body: {
        if (reason != null && reason.isNotEmpty) 'reason': reason.trim(),
      },
    );

    Map<String, dynamic> orderData = {};
    if (response is Map<String, dynamic>) {
      if (response['order'] is Map<String, dynamic>) {
        orderData = response['order'];
      } else if (response['data'] is Map<String, dynamic>) {
        orderData = response['data'];
      } else {
        orderData = response;
      }
    }

    if (orderData.isNotEmpty && orderData.containsKey('id')) {
      return Order.fromJson(orderData);
    }

    return getOrderDetails(id);
  }
}
