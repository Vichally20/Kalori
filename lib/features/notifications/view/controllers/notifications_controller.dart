import 'package:get/get.dart';
import '../../../../shared/shared.dart';
import '../../data/model/notification_item.dart';
import '../../domain/repository/notifications_repository.dart';

/// Controller managing the state and actions for the Notifications screen.
class NotificationsController extends GetxController {
  final NotificationsRepository _repository;

  NotificationsController(this._repository);

  /// Reactive list of all notification items.
  final RxList<NotificationItem> notifications = <NotificationItem>[].obs;

  /// The currently active filter on the notifications screen.
  final Rx<NotificationFilter> selectedFilter = NotificationFilter.all.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  /// Loads or refreshes the notifications from the repository.
  void loadNotifications() {
    notifications.assignAll(_repository.getNotifications());
  }

  /// Returns the number of unread notifications.
  int get unreadCount =>
      notifications.where((item) => !item.isRead.value).length;

  /// Returns the filtered list of notifications depending on [selectedFilter].
  List<NotificationItem> get filteredNotifications {
    switch (selectedFilter.value) {
      case NotificationFilter.unread:
        return notifications.where((item) => !item.isRead.value).toList();
      case NotificationFilter.reminders:
        return notifications
            .where((item) => item.category == NotificationCategory.reminder)
            .toList();
      case NotificationFilter.insights:
        return notifications
            .where((item) => item.category == NotificationCategory.insight)
            .toList();
      case NotificationFilter.achievements:
        return notifications
            .where((item) => item.category == NotificationCategory.achievement)
            .toList();
      case NotificationFilter.all:
        return notifications.toList();
    }
  }

  /// Changes the active filter tab.
  void setFilter(NotificationFilter filter) {
    selectedFilter.value = filter;
  }

  /// Marks a specific notification as read.
  void markAsRead(String id) {
    _repository.markAsRead(id);
    final item = notifications.firstWhereOrNull((element) => element.id == id);
    if (item != null) {
      item.isRead.value = true;
    }
  }

  /// Toggles read state of a notification when tapped directly.
  void toggleReadStatus(String id) {
    final item = notifications.firstWhereOrNull((element) => element.id == id);
    if (item != null) {
      item.isRead.value = !item.isRead.value;
      if (item.isRead.value) {
        _repository.markAsRead(id);
      }
    }
  }

  /// Marks all current notifications as read.
  void markAllAsRead() {
    if (unreadCount == 0) return;
    _repository.markAllAsRead();
    for (final item in notifications) {
      item.isRead.value = true;
    }
    KaloriToast.showSuccess(
      title: 'All Read',
      message: 'All notifications have been marked as read.',
      position: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  /// Deletes a notification by [id].
  void deleteNotification(String id) {
    final removed = notifications.firstWhereOrNull((item) => item.id == id);
    _repository.deleteNotification(id);
    notifications.removeWhere((item) => item.id == id);

    if (removed != null) {
      KaloriToast.showInfo(
        title: 'Notification Removed',
        message: removed.title,
        position: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  /// Clears all notifications.
  void clearAll() {
    if (notifications.isEmpty) return;
    _repository.clearAll();
    notifications.clear();
    KaloriToast.showInfo(
      title: 'Cleared',
      message: 'All notifications have been cleared.',
      position: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  /// Handles action button clicks inside a notification card.
  void handleActionClick(NotificationItem item) {
    markAsRead(item.id);
    if (item.actionRoute != null && item.actionRoute!.isNotEmpty) {
      Get.toNamed(item.actionRoute!);
    } else {
      KaloriToast.showInfo(
        title: item.title,
        message: item.message,
        position: SnackPosition.BOTTOM,
      );
    }
  }
}
