import '../../domain/entities/nutritional_info.dart';
import '../models/food_item_model.dart';

/// Remote AI Data source interface for Gemini / Cloud AI Parsing
abstract class LogRemoteAISource {
  Future<FoodItemModel> parseFoodInput(String query);
}

/// Implementation of [LogRemoteAISource]
class LogRemoteAISourceImpl implements LogRemoteAISource {
  @override
  Future<FoodItemModel> parseFoodInput(String query) async {
    return FoodItemModel(
      title: query,
      subtitle: 'Parsed by AI',
      nutritionalInfo: const NutritionalInfo(calories: 200, carbs: 0, protein: 0, fat: 0),
    );
  }
}
