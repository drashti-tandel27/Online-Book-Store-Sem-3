import '../config/api_config.dart';
import '../models/notification.dart';
import 'api_service.dart';

class NotificationService {
  final ApiService _api = ApiService();

  // Get notifications
  Future<List<AppNotification>> getNotifications() async {
    final response = await _api.get(ApiConfig.notifications);

    List<dynamic> list = [];

    if (response is List) {
      list = response;
    } else if (response is Map<String, dynamic>) {
      if (response['data'] is List) {
        list = response['data'];
      } else if (response['notifications'] is List) {
        list = response['notifications'];
      }
    }

    return list
        .map(
          (item) => AppNotification.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  // Mark one notification as read
  Future<AppNotification?> markAsRead(int notificationId) async {
    final response = await _api.put(
      ApiConfig.markNotificationAsRead(notificationId),
    );

    if (response is Map<String, dynamic>) {
      if (response['data'] is Map<String, dynamic>) {
        return AppNotification.fromJson(
          response['data'] as Map<String, dynamic>,
        );
      }
    }

    return null;
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    await _api.put(
      ApiConfig.markAllNotificationsAsRead,
    );
  }

  // Delete notification
  Future<void> deleteNotification(int notificationId) async {
    await _api.delete(
      ApiConfig.deleteNotification(notificationId),
    );
  }
}