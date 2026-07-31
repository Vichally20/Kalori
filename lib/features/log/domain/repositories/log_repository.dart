import '../entities/food_item.dart';

/// Domain repository contract for Meal Logging
abstract class LogRepository {
  Future<List<FoodItem>> getMealItems();
  Future<void> saveMealItem(FoodItem item);
}
