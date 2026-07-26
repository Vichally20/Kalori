import '../entities/meal_food_item.dart';

/// Domain repository contract for Meal Logging
abstract class LogRepository {
  Future<List<MealFoodItem>> getMealItems();
  Future<void> saveMealItem(MealFoodItem item);
}
