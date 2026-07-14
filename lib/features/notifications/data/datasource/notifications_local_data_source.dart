import '../model/notification_item.dart';

/// Local data source providing in-memory storage and initial rich mock notifications.
class NotificationsLocalDataSource {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Daily Meal Log Reminder 🥗',
      message:
          'You have 1,460 kcal remaining today. Make sure to log your dinner to stay on track with your nutrition goals!',
      timestamp: '10m ago',
      category: NotificationCategory.reminder,
      isRead: false,
      actionLabel: 'Log Dinner',
      actionRoute: '/log',
    ),
    NotificationItem(
      id: '2',
      title: '3-Day Protein Streak! 🔥',
      message:
          "Awesome work! You've successfully hit your daily 130g protein target for 3 consecutive days.",
      timestamp: '2h ago',
      category: NotificationCategory.achievement,
      isRead: false,
      actionLabel: 'View Stats',
      actionRoute: '/home',
    ),
    NotificationItem(
      id: '3',
      title: 'AI Nutrition Insight 💡',
      message:
          'Your breakfast had great fiber content today! Adding a handful of almonds or berries could boost your afternoon energy.',
      timestamp: '5h ago',
      category: NotificationCategory.insight,
      isRead: true,
      actionLabel: 'See Tips',
      actionRoute: '/home',
    ),
    NotificationItem(
      id: '4',
      title: 'Hydration Check 💧',
      message:
          "You're halfway through the day. Have you drank your 5th glass of water yet? Tap to update your water log.",
      timestamp: 'Yesterday',
      category: NotificationCategory.reminder,
      isRead: true,
      actionLabel: 'Log Water',
      actionRoute: '/home',
    ),
    NotificationItem(
      id: '5',
      title: 'Weekly Summary Ready 📊',
      message:
          'Your calorie deficit for last week averaged 320 kcal/day with excellent macro balance. Check out the full breakdown.',
      timestamp: '2 days ago',
      category: NotificationCategory.system,
      isRead: true,
      actionLabel: 'View Summary',
      actionRoute: '/history',
    ),
  ];

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
