import '../../domain/entities/notification_item.dart';

/// Data model extending [NotificationItem]
class NotificationItemModel extends NotificationItem {
  NotificationItemModel({
    required super.id,
    required super.title,
    required super.message,
    required super.timestamp,
    required super.category,
    super.isRead,
    super.actionLabel,
    super.actionRoute,
  });

  factory NotificationItemModel.fromEntity(NotificationItem entity) {
    return NotificationItemModel(
      id: entity.id,
      title: entity.title,
      message: entity.message,
      timestamp: entity.timestamp,
      category: entity.category,
      isRead: entity.isRead.value,
      actionLabel: entity.actionLabel,
      actionRoute: entity.actionRoute,
    );
  }
}
