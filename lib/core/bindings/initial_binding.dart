import 'package:get/get.dart';
import '../../features/notifications/data/datasource/notifications_local_data_source.dart';
import '../../features/notifications/data/repository/notifications_repository_impl.dart';
import '../../features/notifications/domain/repository/notifications_repository.dart';
import '../../features/notifications/view/controllers/notifications_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Global notification dependencies so badge status and notifications are always active across tabs
    Get.lazyPut<NotificationsLocalDataSource>(
      () => NotificationsLocalDataSource(),
      fenix: true,
    );
    Get.lazyPut<NotificationsRepository>(
      () => NotificationsRepositoryImpl(Get.find<NotificationsLocalDataSource>()),
      fenix: true,
    );
    Get.lazyPut<NotificationsController>(
      () => NotificationsController(Get.find<NotificationsRepository>()),
      fenix: true,
    );
  }
}
