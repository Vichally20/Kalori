import 'package:get/get.dart';
import '../../data/datasource/notifications_local_data_source.dart';
import '../../data/repository/notifications_repository_impl.dart';
import '../../domain/repository/notifications_repository.dart';
import '../controllers/notifications_controller.dart';

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
