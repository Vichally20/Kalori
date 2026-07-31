import '../models/food_item_model.dart';

/// Local data source interface for meal logs storage
abstract class LogLocalDataSource {
  Future<List<FoodItemModel>> getSavedMealItems();
  Future<void> saveMealItem(FoodItemModel item);
}

/// Implementation of [LogLocalDataSource] using local database / Hive Box
class LogLocalDataSourceImpl implements LogLocalDataSource {
  @override
  Future<List<FoodItemModel>> getSavedMealItems() async {
    return [];
  }

  @override
  Future<void> saveMealItem(FoodItemModel item) async {
    // Local persistence logic
  }
}
