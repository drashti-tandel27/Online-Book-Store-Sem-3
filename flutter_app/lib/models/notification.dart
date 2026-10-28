import 'order.dart';

class AppNotification {
  final int id;
  final int userId;
  final int? orderId;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final String? createdAt;
  final Order? order;

  AppNotification({
    required this.id,
    required this.userId,
    this.orderId,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    this.createdAt,
    this.order,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      orderId: json['order_id'],
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'general',
      isRead: json['is_read'] ?? false,
      createdAt: json['created_at'],
      order: json['order'] != null
          ? Order.fromJson(json['order'])
          : null,
    );
  }
}