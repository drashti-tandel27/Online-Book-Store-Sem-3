import 'order_item.dart';

class Order {
  final int id;
  final String orderNumber;
  final int? userId;
  final String status;
  final double subtotal;
  final double shippingFee;
  final double tax;
  final double totalAmount;
  final String paymentMethod;
  final String? paymentStatus;
  final String shippingAddress;
  final String? recipientName;
  final String? recipientPhone;
  final String? notes;
  final String? createdAt;
  final String? updatedAt;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.orderNumber,
    this.userId,
    required this.status,
    required this.subtotal,
    this.shippingFee = 0.0,
    this.tax = 0.0,
    required this.totalAmount,
    required this.paymentMethod,
    this.paymentStatus,
    required this.shippingAddress,
    this.recipientName,
    this.recipientPhone,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.items = const [],
  });

  bool get canCancel =>
      status.toLowerCase() == 'pending' || status.toLowerCase() == 'confirmed';

  bool get isDelivered => status.toLowerCase() == 'delivered';
  bool get isCancelled => status.toLowerCase() == 'cancelled';

  int get statusStepIndex {
    switch (status.toLowerCase()) {
      case 'pending':
        return 0;
      case 'confirmed':
        return 1;
      case 'processing':
        return 2;
      case 'shipped':
        return 3;
      case 'delivered':
        return 4;
      default:
        return -1;
    }
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    List<OrderItem> parsedItems = [];
    if (json['items'] != null && json['items'] is List) {
      parsedItems = (json['items'] as List)
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } else if (json['order_items'] != null && json['order_items'] is List) {
      parsedItems = (json['order_items'] as List)
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return Order(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      orderNumber: json['order_number']?.toString() ??
          json['order_no']?.toString() ??
          '#ORD-${json['id']}',
      userId: json['user_id'] is int
          ? json['user_id']
          : int.tryParse(json['user_id']?.toString() ?? ''),
      status: json['status']?.toString() ?? 'Pending',
      subtotal: json['subtotal'] is num
          ? (json['subtotal'] as num).toDouble()
          : double.tryParse(json['subtotal']?.toString() ?? '0.0') ?? 0.0,
      shippingFee: json['shipping_fee'] is num
          ? (json['shipping_fee'] as num).toDouble()
          : double.tryParse(json['shipping_fee']?.toString() ?? '0.0') ?? 0.0,
      tax: json['tax'] is num
          ? (json['tax'] as num).toDouble()
          : double.tryParse(json['tax']?.toString() ?? '0.0') ?? 0.0,
      totalAmount: json['total_amount'] is num
          ? (json['total_amount'] as num).toDouble()
          : (json['total'] is num
              ? (json['total'] as num).toDouble()
              : double.tryParse(json['total_amount']?.toString() ?? json['total']?.toString() ?? '0.0') ?? 0.0),
      paymentMethod: json['payment_method']?.toString() ?? 'Cash on Delivery',
      paymentStatus: json['payment_status']?.toString() ?? 'Pending',
      shippingAddress: json['shipping_address']?.toString() ??
          json['address']?.toString() ??
          '',
      recipientName: json['recipient_name']?.toString() ?? json['name']?.toString(),
      recipientPhone: json['recipient_phone']?.toString() ?? json['phone']?.toString(),
      notes: json['notes']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      items: parsedItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'user_id': userId,
      'status': status,
      'subtotal': subtotal,
      'shipping_fee': shippingFee,
      'tax': tax,
      'total_amount': totalAmount,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'shipping_address': shippingAddress,
      'recipient_name': recipientName,
      'recipient_phone': recipientPhone,
      'notes': notes,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
