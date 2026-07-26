import '../models/meal_food_item_model.dart';

/// Local data source interface for meal logs storage
abstract class LogLocalDataSource {
  Future<List<MealFoodItemModel>> getSavedMealItems();
  Future<void> saveMealItem(MealFoodItemModel item);
}

/// Implementation of [LogLocalDataSource] using local database / Hive Box
class LogLocalDataSourceImpl implements LogLocalDataSource {
  @override
  Future<List<MealFoodItemModel>> getSavedMealItems() async {
    return [];
  }

  @override
  Future<void> saveMealItem(MealFoodItemModel item) async {
    // Local persistence logic
  }
}
