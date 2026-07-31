import '../../../log/data/models/food_item_model.dart';

/// Data source interface for home local storage
abstract class HomeLocalDataSource {
  Future<List<FoodItemModel>> getRecentLogs();
  Future<void> cacheRecentLog(FoodItemModel logItem);
}

/// Implementation of [HomeLocalDataSource]
class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  @override
  Future<List<FoodItemModel>> getRecentLogs() async {
    return [];
  }

  @override
  Future<void> cacheRecentLog(FoodItemModel logItem) async {
    // Local storage caching implementation
  }
}
