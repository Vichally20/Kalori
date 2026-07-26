import '../entities/food_log_item.dart';

/// Domain repository contract for Home feature
abstract class HomeRepository {
  Future<List<FoodLogItem>> getRecentLogs();
  Future<void> saveFoodLog(FoodLogItem item);
}
