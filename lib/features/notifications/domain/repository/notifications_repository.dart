import '../../data/model/notification_item.dart';

/// Domain repository interface for managing notifications.
abstract class NotificationsRepository {
  /// Returns the current list of notifications.
  List<NotificationItem> getNotifications();

  /// Marks a specific notification as read by [id].
  void markAsRead(String id);

  /// Marks all notifications as read.
  void markAllAsRead();

  /// Deletes a specific notification by [id].
  void deleteNotification(String id);

  /// Clears all notifications.
  void clearAll();

  /// Adds a new notification item.
  void addNotification(NotificationItem item);
}
