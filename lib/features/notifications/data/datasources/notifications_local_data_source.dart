import 'package:kalori/features/notifications/domain/entities/notification_item.dart';

/// In-memory notifications store. Starts empty; features add real notifications
/// through [addNotification] as events happen.
class NotificationsLocalDataSource {
  final List<NotificationItem> _notifications = <NotificationItem>[];

  /// Returns a copy of the current notifications list.
  List<NotificationItem> getNotifications() => List.from(_notifications);

  /// Marks the notification with [id] as read.
  void markAsRead(String id) {
    final index = _notifications.indexWhere((item) => item.id == id);
    if (index != -1) {
      _notifications[index].isRead.value = true;
    }
  }

  /// Marks all notifications as read.
  void markAllAsRead() {
    for (final item in _notifications) {
      item.isRead.value = true;
    }
  }

  /// Deletes the notification with [id].
  void deleteNotification(String id) {
    _notifications.removeWhere((item) => item.id == id);
  }

  /// Clears all notifications.
  void clearAll() {
    _notifications.clear();
  }

  /// Adds a new notification item.
  void addNotification(NotificationItem item) {
    _notifications.insert(0, item);
  }
}
