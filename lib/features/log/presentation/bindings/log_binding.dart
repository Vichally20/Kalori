import 'package:get/get.dart';
import 'package:kalori/features/log/data/datasources/log_local_data_source.dart';
import 'package:kalori/features/log/data/repositories/log_repository_impl.dart';
import 'package:kalori/features/log/domain/repositories/log_repository.dart';
import 'package:kalori/features/log/domain/usecases/get_frequent_meals.dart';
import 'package:kalori/features/log/domain/usecases/get_meals.dart';
import 'package:kalori/features/log/domain/usecases/log_meal.dart';
import 'package:kalori/features/log/presentation/controllers/log_controller.dart';

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
