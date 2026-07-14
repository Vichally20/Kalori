import 'package:get/get.dart';

/// Categories for notifications in Kalori.
enum NotificationCategory {
  reminder,
  achievement,
  insight,
  system,
  social,
}

/// Filters available on the Notifications screen.
enum NotificationFilter {
  all,
  unread,
  reminders,
  insights,
  achievements,
}

/// Data model representing a single notification item in the app.
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String timestamp;
  final NotificationCategory category;
  final RxBool isRead;
  final String? actionLabel;
  final String? actionRoute;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.category,
    bool isRead = false,
    this.actionLabel,
    this.actionRoute,
  }) : isRead = isRead.obs;

  /// Creates a copy of this [NotificationItem] with optional updated fields.
  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    String? timestamp,
    NotificationCategory? category,
    bool? isRead,
    String? actionLabel,
    String? actionRoute,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      category: category ?? this.category,
      isRead: isRead ?? this.isRead.value,
      actionLabel: actionLabel ?? this.actionLabel,
      actionRoute: actionRoute ?? this.actionRoute,
    );
  }
}
