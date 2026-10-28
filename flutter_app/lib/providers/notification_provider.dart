import 'package:flutter/material.dart';
import '../models/notification.dart';
import '../services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _notificationService =
      NotificationService();

  List<AppNotification> _notifications = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<AppNotification> get notifications => _notifications;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  int get unreadCount =>
      _notifications.where((notification) => !notification.isRead).length;

  bool get hasUnread => unreadCount > 0;

  // Fetch notifications
  Future<void> fetchNotifications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _notifications =
          await _notificationService.getNotifications();
    } catch (e) {
      _errorMessage =
          e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mark one notification as read
  Future<void> markAsRead(int notificationId) async {
    try {
      await _notificationService.markAsRead(notificationId);

      final index = _notifications.indexWhere(
        (notification) => notification.id == notificationId,
      );

      if (index != -1) {
        final old = _notifications[index];

        _notifications[index] = AppNotification(
          id: old.id,
          userId: old.userId,
          orderId: old.orderId,
          title: old.title,
          message: old.message,
          type: old.type,
          isRead: true,
          createdAt: old.createdAt,
          order: old.order,
        );

        notifyListeners();
      }
    } catch (e) {
      _errorMessage =
          e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  // Mark all as read
  Future<void> markAllAsRead() async {
    try {
      await _notificationService.markAllAsRead();

      _notifications = _notifications.map((notification) {
        return AppNotification(
          id: notification.id,
          userId: notification.userId,
          orderId: notification.orderId,
          title: notification.title,
          message: notification.message,
          type: notification.type,
          isRead: true,
          createdAt: notification.createdAt,
          order: notification.order,
        );
      }).toList();

      notifyListeners();
    } catch (e) {
      _errorMessage =
          e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  // Delete notification
  Future<void> deleteNotification(int notificationId) async {
    try {
      await _notificationService.deleteNotification(
        notificationId,
      );

      _notifications.removeWhere(
        (notification) => notification.id == notificationId,
      );

      notifyListeners();
    } catch (e) {
      _errorMessage =
          e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  // Clear local notifications
  void clear() {
    _notifications = [];
    _errorMessage = null;
    notifyListeners();
  }
}