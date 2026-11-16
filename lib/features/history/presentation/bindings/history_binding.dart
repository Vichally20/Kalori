import 'package:get/get.dart';
import 'package:kalori/features/history/presentation/controllers/history_controller.dart';
import 'package:kalori/features/log/data/datasources/log_local_data_source.dart';
import 'package:kalori/features/log/data/repositories/log_repository_impl.dart';
import 'package:kalori/features/log/domain/repositories/log_repository.dart';
import 'package:kalori/features/log/domain/usecases/watch_meals.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    // Meal data source. Usually already registered by LogBinding (via HomeBinding);
    // lazyPut skips types that are already registered.
    Get.lazyPut<LogLocalDataSource>(() => LogLocalDataSourceImpl());
    Get.lazyPut<LogRepository>(
      () => LogRepositoryImpl(localDataSource: Get.find<LogLocalDataSource>()),
    );
    Get.lazyPut<WatchMeals>(() => WatchMeals(Get.find<LogRepository>()));

    // fenix: Day detail re-finds the controller after the History tab created it.
    Get.lazyPut<HistoryController>(() => HistoryController(), fenix: true);
  }
}
