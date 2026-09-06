import 'package:kalori/features/log/domain/entities/chat_message.dart';
import 'package:kalori/features/log/domain/entities/food_parse_result.dart';
import 'package:kalori/features/log/domain/repositories/food_parser_repository.dart';

/// Usecase for analyzing raw natural language / external food data
class AnalyzeFoodInput {
  final FoodParserRepository parserRepository;

  AnalyzeFoodInput(this.parserRepository);

  Future<FoodParseResult> execute(String rawInput, [List<ChatMessage> history = const []]) async {
    return await parserRepository.parseFood(rawInput, history);
  }
}
