import 'package:get/get.dart';
import 'package:kalori/features/history/presentation/bindings/history_binding.dart';
import 'package:kalori/features/home/data/datasources/home_local_data_source.dart';
import 'package:kalori/features/home/data/repositories/home_repository_impl.dart';
import 'package:kalori/features/home/domain/repositories/home_repository.dart';
import 'package:kalori/features/home/domain/usecases/get_recent_logs.dart';
import 'package:kalori/features/home/presentation/controllers/home_controller.dart';
import 'package:kalori/features/log/presentation/bindings/log_binding.dart';
import 'package:kalori/features/profile/presentation/bindings/profile_binding.dart';

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
