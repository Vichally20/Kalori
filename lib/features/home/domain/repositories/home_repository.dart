import '../../../log/domain/entities/food_item.dart';

/// Domain repository contract for Home feature
abstract class HomeRepository {
  Future<List<FoodItem>> getRecentLogs();
  Future<void> saveFoodLog(FoodItem item);
}
