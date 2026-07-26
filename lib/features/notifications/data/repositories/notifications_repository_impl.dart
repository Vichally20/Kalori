import '../../domain/entities/notification_item.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_local_data_source.dart';

/// Implementation of [NotificationsRepository] using local storage / in-memory data source.
class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsLocalDataSource _localDataSource;

  NotificationsRepositoryImpl(this._localDataSource);

  @override
  List<NotificationItem> getNotifications() {
    return _localDataSource.getNotifications();
  }

  @override
  void markAsRead(String id) {
    _localDataSource.markAsRead(id);
  }

  @override
  void markAllAsRead() {
    _localDataSource.markAllAsRead();
  }

  @override
  void deleteNotification(String id) {
    _localDataSource.deleteNotification(id);
  }

  @override
  void clearAll() {
    _localDataSource.clearAll();
  }

  @override
  void addNotification(NotificationItem item) {
    _localDataSource.addNotification(item);
  }
}
