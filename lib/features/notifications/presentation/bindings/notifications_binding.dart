import 'package:get/get.dart';
import 'package:kalori/features/notifications/data/datasources/notifications_local_data_source.dart';
import 'package:kalori/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:kalori/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:kalori/features/notifications/presentation/controllers/notifications_controller.dart';

/// Binding for the Notifications screen.
class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<NotificationsLocalDataSource>()) {
      Get.lazyPut<NotificationsLocalDataSource>(
        () => NotificationsLocalDataSource(),
        fenix: true,
      );
    }
    if (!Get.isRegistered<NotificationsRepository>()) {
      Get.lazyPut<NotificationsRepository>(
        () => NotificationsRepositoryImpl(
            Get.find<NotificationsLocalDataSource>()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<NotificationsController>()) {
      Get.lazyPut<NotificationsController>(
        () => NotificationsController(Get.find<NotificationsRepository>()),
        fenix: true,
      );
    }
  }
}
