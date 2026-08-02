import 'package:kalori/features/log/domain/repositories/log_repository.dart';
import 'package:kalori/features/log/domain/entities/food_item.dart';

class GetMealsUsecase {
  final LogRepository repository;

  GetMealsUsecase(this.repository);

  Future<List<FoodItem>> execute() async {
    return await repository.getMealItems();
  }
}
