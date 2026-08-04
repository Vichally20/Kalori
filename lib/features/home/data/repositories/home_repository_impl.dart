import '../../../log/domain/entities/food_item.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_data_source.dart';

/// Data repository implementation for [HomeRepository]
class HomeRepositoryImpl implements HomeRepository {
  final HomeLocalDataSource localDataSource;

  HomeRepositoryImpl({required this.localDataSource});

  @override
  Future<List<FoodItem>> getRecentLogs() async {
    return await localDataSource.getRecentLogs();
  }

}
