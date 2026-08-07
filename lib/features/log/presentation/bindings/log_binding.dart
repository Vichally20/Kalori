import 'package:get/get.dart';
import '../../domain/repositories/log_repository.dart';
import '../../data/repositories/log_repository_impl.dart';
import '../../data/datasources/log_local_data_source.dart';
import '../../domain/usecases/get_meals.dart';
import '../../domain/usecases/log_meal.dart';
import '../../domain/usecases/get_frequent_meals.dart';
import '../controllers/log_controller.dart';

class LogBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LogLocalDataSource>(() => LogLocalDataSourceImpl());
    Get.lazyPut<LogRepository>(() => LogRepositoryImpl(localDataSource: Get.find<LogLocalDataSource>()));
    Get.lazyPut<GetMealsUsecase>(() => GetMealsUsecase(Get.find<LogRepository>()));
    Get.lazyPut<LogMeal>(() => LogMeal(Get.find<LogRepository>()));
    Get.lazyPut<GetFrequentMeals>(() => GetFrequentMeals(Get.find<LogRepository>()));
    Get.lazyPut<LogController>(() => LogController());
  }
}
