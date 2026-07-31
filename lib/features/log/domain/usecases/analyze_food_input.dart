import '../entities/food_item.dart';
import '../repositories/food_parser_repository.dart';

/// Usecase for analyzing natural language or image food input (can act as MCP Tool)
class AnalyzeFoodInput {
  final FoodParserRepository parserRepository;

  AnalyzeFoodInput(this.parserRepository);

  Future<FoodItem> execute(String input) async {
    return await parserRepository.parseFood(input);
  }
}
