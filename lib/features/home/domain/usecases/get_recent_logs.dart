import 'package:kalori/features/home/domain/repositories/home_repository.dart';
import 'package:kalori/features/log/domain/entities/food_item.dart';

class GetRecentLogs {
  final HomeRepository repository;

  GetRecentLogs(this.repository);

  Future<List<FoodItem>> execute() async {
    return await repository.getRecentLogs();
  }
}