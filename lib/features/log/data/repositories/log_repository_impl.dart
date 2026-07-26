import '../../domain/entities/meal_food_item.dart';
import '../../domain/repositories/log_repository.dart';
import '../datasources/log_local_data_source.dart';
import '../models/meal_food_item_model.dart';

/// Data repository implementation for [LogRepository]
class LogRepositoryImpl implements LogRepository {
  final LogLocalDataSource localDataSource;

  LogRepositoryImpl({required this.localDataSource});

  @override
  Future<List<MealFoodItem>> getMealItems() async {
    return await localDataSource.getSavedMealItems();
  }

  @override
  Future<void> saveMealItem(MealFoodItem item) async {
    await localDataSource.saveMealItem(MealFoodItemModel.fromEntity(item));
  }
}
