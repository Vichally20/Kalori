import '../entities/food_item.dart';
import '../repositories/log_repository.dart';

class GetFrequentMeals {
  final LogRepository repository;

  GetFrequentMeals(this.repository);

  Future<List<FoodItem>> execute({int limit = 3}) async {
    return await repository.getFrequentMeals(limit: limit);
  }
}
