import 'package:kalori/features/home/data/datasources/home_local_data_source.dart';
import 'package:kalori/features/home/domain/repositories/home_repository.dart';
import 'package:kalori/features/log/domain/entities/food_item.dart';

/// Data repository implementation for [HomeRepository]
class HomeRepositoryImpl implements HomeRepository {
  final HomeLocalDataSource localDataSource;

  HomeRepositoryImpl({required this.localDataSource});

  @override
  Future<List<FoodItem>> getRecentLogs() async {
    return await localDataSource.getRecentLogs();
  }

}
