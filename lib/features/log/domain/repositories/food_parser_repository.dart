import 'package:kalori/features/log/domain/entities/chat_message.dart';
import 'package:kalori/features/log/domain/entities/food_parse_result.dart';

/// The AI Bridge interface for parsing natural language / image inputs to meals
abstract class FoodParserRepository {
  Future<FoodParseResult> parseFood(String input, [List<ChatMessage> history = const []]);
}
