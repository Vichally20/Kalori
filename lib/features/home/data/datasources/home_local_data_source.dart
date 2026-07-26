import '../models/food_log_item_model.dart';

/// Data source interface for home local storage
abstract class HomeLocalDataSource {
  Future<List<FoodLogItemModel>> getRecentLogs();
  Future<void> cacheRecentLog(FoodLogItemModel logItem);
}

/// Implementation of [HomeLocalDataSource]
class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  @override
  Future<List<FoodLogItemModel>> getRecentLogs() async {
    return [];
  }

  @override
  Future<void> cacheRecentLog(FoodLogItemModel logItem) async {
    // Local storage caching implementation
  }
}
