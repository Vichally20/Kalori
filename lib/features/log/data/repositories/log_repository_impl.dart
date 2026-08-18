import 'package:kalori/features/log/data/datasources/log_local_data_source.dart';
import 'package:kalori/features/log/data/models/food_item_model.dart';
import 'package:kalori/features/log/domain/entities/food_item.dart';
import 'package:kalori/features/log/domain/repositories/log_repository.dart';

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
