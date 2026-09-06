import 'package:kalori/features/log/data/datasources/log_remote_ai_source.dart';
import 'package:kalori/features/log/domain/entities/chat_message.dart';
import 'package:kalori/features/log/domain/entities/food_parse_result.dart';
import 'package:kalori/features/log/domain/repositories/food_parser_repository.dart';

class FoodParserRepositoryImpl implements FoodParserRepository {
  final LogRemoteAISource remoteDataSource;

  FoodParserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<FoodParseResult> parseFood(String input, [List<ChatMessage> history = const []]) async {
    return await remoteDataSource.parseFoodInput(input, history);
  }
}
