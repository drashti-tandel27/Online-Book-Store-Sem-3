import 'cart_item.dart';

class Cart {
  final int? id;
  final int? userId;
  final List<CartItem> items;

  Cart({
    this.id,
    this.userId,
    required this.items,
  });

  int get totalItemsCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.subtotal);

  // Delivery fee logic (e.g. Free shipping above $50, else $4.99)
  double get shippingFee => subtotal > 50.0 || items.isEmpty ? 0.0 : 4.99;

  // Tax calculation (e.g., 5%)
  double get tax => subtotal * 0.05;

  double get totalAmount => subtotal + shippingFee + tax;

  bool get isEmpty => items.isEmpty;

  factory Cart.fromJson(Map<String, dynamic> json) {
    List<CartItem> parsedItems = [];
    if (json['items'] != null && json['items'] is List) {
      parsedItems = (json['items'] as List)
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } else if (json['cart_items'] != null && json['cart_items'] is List) {
      parsedItems = (json['cart_items'] as List)
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return Cart(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      userId: json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id']?.toString() ?? ''),
      items: parsedItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
