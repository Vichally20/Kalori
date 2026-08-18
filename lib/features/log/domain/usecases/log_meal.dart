import 'package:kalori/features/log/domain/entities/food_item.dart';
import 'package:kalori/features/log/domain/repositories/log_repository.dart';

/// Usecase for logging a meal item
class LogMeal {
  final LogRepository logRepository;

  LogMeal(this.logRepository);

  Future<void> execute(FoodItem item) async {
    await logRepository.saveMealItem(item);
  }
}
