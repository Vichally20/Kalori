import 'package:kalori/features/log/data/datasources/log_remote_ai_source.dart';
import 'package:kalori/features/log/domain/entities/food_item.dart';
import 'package:kalori/features/log/domain/repositories/food_parser_repository.dart';

/// Swappable repository implementation (Manual -> AI)
class FoodParserRepositoryImpl implements FoodParserRepository {
  final LogRemoteAISource aiSource;

  FoodParserRepositoryImpl({required this.aiSource});

  @override
  Future<FoodItem> parseFood(String input) async {
    return await aiSource.parseFoodInput(input);
  }
}
