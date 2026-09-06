import 'package:kalori/features/log/domain/entities/meal_log_entry.dart';
import 'package:kalori/features/log/domain/repositories/log_repository.dart';

class WatchMeals {
  final LogRepository repository;

  WatchMeals(this.repository);

  Stream<List<MealLogEntry>> execute() {
    return repository.watchMealItems();
  }
}
