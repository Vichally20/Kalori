import '../models/meal_food_item_model.dart';

/// Remote AI Data source interface for Gemini / Cloud AI Parsing
abstract class LogRemoteAISource {
  Future<MealFoodItemModel> parseFoodInput(String query);
}

/// Implementation of [LogRemoteAISource]
class LogRemoteAISourceImpl implements LogRemoteAISource {
  @override
  Future<MealFoodItemModel> parseFoodInput(String query) async {
    return MealFoodItemModel(
      title: query,
      subtitle: 'Parsed by AI',
      calories: '200 kcal',
    );
  }
}
