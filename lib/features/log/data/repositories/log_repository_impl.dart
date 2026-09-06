import 'package:kalori/features/log/data/datasources/log_local_data_source.dart';
import 'package:kalori/features/log/data/models/meal_log_entry_model.dart';
import 'package:kalori/features/log/domain/entities/food_item.dart';
import 'package:kalori/features/log/domain/entities/meal_log_entry.dart';
import 'package:kalori/features/log/domain/repositories/log_repository.dart';

/// Data repository implementation for [LogRepository]
class LogRepositoryImpl implements LogRepository {
  final LogLocalDataSource localDataSource;

  LogRepositoryImpl({required this.localDataSource});

  @override
  Future<List<MealLogEntry>> getMealItems() async {
    return await localDataSource.getSavedMealItems();
  }

  @override
  Stream<List<MealLogEntry>> watchMealItems() {
    return localDataSource.watchMealItems();
  }

  @override
  Future<List<FoodItem>> getFrequentMeals({int limit = 3}) async {
    return await localDataSource.getFrequentMeals(limit: limit);
  }

  @override
  Future<void> saveMealItem(MealLogEntry item) async {
    await localDataSource.saveMealItem(MealLogEntryModel.fromEntity(item));
  }

  @override
  Future<void> deleteMealItem(String id) async {
    await localDataSource.deleteMealItem(id);
  }
}
