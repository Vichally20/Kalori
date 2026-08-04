import '../entities/food_item.dart';

/// Domain repository contract for Meal Logging
abstract class LogRepository {
  Future<List<FoodItem>> getMealItems();
  Future<List<FoodItem>> getFrequentMeals({int limit = 3});
  Future<void> saveMealItem(FoodItem item);
}
