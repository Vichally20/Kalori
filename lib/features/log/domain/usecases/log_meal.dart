import '../entities/food_item.dart';
import '../repositories/log_repository.dart';

/// Usecase for logging a meal item
class LogMeal {
  final LogRepository logRepository;

  LogMeal(this.logRepository);

  Future<void> execute(FoodItem item) async {
    await logRepository.saveMealItem(item);
  }
}
