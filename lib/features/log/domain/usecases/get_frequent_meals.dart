import 'package:kalori/features/log/domain/entities/food_item.dart';
import 'package:kalori/features/log/domain/repositories/log_repository.dart';

class GetFrequentMeals {
  final LogRepository repository;

  GetFrequentMeals(this.repository);

  Future<List<FoodItem>> execute({int limit = 3}) async {
    return await repository.getFrequentMeals(limit: limit);
  }
}
