import '../../domain/entities/food_item.dart';
import '../../domain/repositories/log_repository.dart';
import '../datasources/log_local_data_source.dart';
import '../models/food_item_model.dart';

/// Data repository implementation for [LogRepository]
class LogRepositoryImpl implements LogRepository {
  final LogLocalDataSource localDataSource;

  LogRepositoryImpl({required this.localDataSource});

  @override
  Future<List<FoodItem>> getMealItems() async {
    return await localDataSource.getSavedMealItems();
  }

  @override
  Future<List<FoodItem>> getFrequentMeals({int limit = 3}) async {
    return await localDataSource.getFrequentMeals(limit: limit);
  }

  @override
  Future<void> saveMealItem(FoodItem item) async {
    await localDataSource.saveMealItem(FoodItemModel.fromEntity(item));
  }
}
