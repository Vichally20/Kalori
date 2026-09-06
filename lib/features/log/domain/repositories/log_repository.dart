import 'package:kalori/features/log/domain/entities/food_item.dart';
import 'package:kalori/features/log/domain/entities/meal_log_entry.dart';

/// Domain repository contract for Meal Logging
abstract class LogRepository {
  Future<List<MealLogEntry>> getMealItems();
  Stream<List<MealLogEntry>> watchMealItems();
  Future<List<FoodItem>> getFrequentMeals({int limit = 3});
  Future<void> saveMealItem(MealLogEntry item);
}
