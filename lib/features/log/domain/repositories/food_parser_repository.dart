import '../entities/food_item.dart';

/// The AI Bridge interface for parsing natural language / image inputs to meals
abstract class FoodParserRepository {
  Future<FoodItem> parseFood(String input);
}
