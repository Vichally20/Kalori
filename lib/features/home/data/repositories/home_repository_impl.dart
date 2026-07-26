import '../../domain/entities/food_log_item.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_data_source.dart';
import '../models/food_log_item_model.dart';

/// Data repository implementation for [HomeRepository]
class HomeRepositoryImpl implements HomeRepository {
  final HomeLocalDataSource localDataSource;

  HomeRepositoryImpl({required this.localDataSource});

  @override
  Future<List<FoodLogItem>> getRecentLogs() async {
    return await localDataSource.getRecentLogs();
  }

  @override
  Future<void> saveFoodLog(FoodLogItem item) async {
    await localDataSource.cacheRecentLog(FoodLogItemModel.fromEntity(item));
  }
}
