import '../../domain/entities/meal_food_item.dart';
import '../../domain/repositories/food_parser_repository.dart';
import '../datasources/log_remote_ai_source.dart';

/// Swappable repository implementation (Manual -> AI)
class FoodParserRepositoryImpl implements FoodParserRepository {
  final LogRemoteAISource aiSource;

  FoodParserRepositoryImpl({required this.aiSource});

  @override
  Future<MealFoodItem> parseFood(String input) async {
    return await aiSource.parseFoodInput(input);
  }
}
