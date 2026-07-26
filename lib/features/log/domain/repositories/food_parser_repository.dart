import '../entities/meal_food_item.dart';

/// The AI Bridge interface for parsing natural language / image inputs to meals
abstract class FoodParserRepository {
  Future<MealFoodItem> parseFood(String input);
}
