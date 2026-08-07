import 'package:get/get.dart';
import '../../../history/presentation/bindings/history_binding.dart';
import '../../../log/presentation/bindings/log_binding.dart';
import '../../../profile/presentation/bindings/profile_binding.dart';
import '../../domain/repositories/home_repository.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../data/datasources/home_local_data_source.dart';
import '../../domain/usecases/get_recent_logs.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeLocalDataSource>(() => HomeLocalDataSourceImpl());
    Get.lazyPut<HomeRepository>(() => HomeRepositoryImpl(localDataSource: Get.find<HomeLocalDataSource>()));
    Get.lazyPut<GetRecentLogs>(() => GetRecentLogs(Get.find<HomeRepository>()));
    Get.lazyPut<HomeController>(() => HomeController());

    // Initialize bindings for all tab views since they are children of HomeView
    LogBinding().dependencies();
    HistoryBinding().dependencies();
    ProfileBinding().dependencies();
  }
}
