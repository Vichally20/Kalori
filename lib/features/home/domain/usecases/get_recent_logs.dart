import 'package:kalori/features/log/domain/entities/food_item.dart';

import '../repositories/home_repository.dart';

class GetRecentLogs {
  final HomeRepository repository;

  GetRecentLogs(this.repository);

  Future<List<FoodItem>> execute() async {
    return await repository.getRecentLogs();
  }
}