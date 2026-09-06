import 'package:get/get.dart';
import 'package:kalori/core/utilities/app_logger.dart';
import 'package:kalori/features/log/domain/entities/chat_message.dart';
import 'package:kalori/features/log/domain/entities/food_parse_result.dart';
import 'package:kalori/features/log/domain/entities/meal_log_entry.dart';
import 'package:kalori/features/log/domain/entities/sync_status.dart';
import 'package:kalori/features/log/domain/repositories/log_repository.dart';
import 'package:kalori/features/log/domain/usecases/analyze_food_input.dart';
import 'package:uuid/uuid.dart';

/// Usecase for logging a meal item
class LogMeal {
  final LogRepository logRepository;
  final AnalyzeFoodInput analyzeFoodInput;
  final Uuid uuid = const Uuid();

  LogMeal(this.logRepository, this.analyzeFoodInput);

  Future<FoodParseResult> execute(String rawInput, [List<ChatMessage> history = const []]) async {
    AppLogger.i('LogMeal execute requested with input: "$rawInput"');
    
    final entry = MealLogEntry(
      id: uuid.v4(),
      rawInput: rawInput,
      syncStatus: SyncStatus.pending,
      createdAt: DateTime.now(),
    );
    await logRepository.saveMealItem(entry);
    AppLogger.d('Saved pending meal entry locally with ID: ${entry.id}');
    
    return await _syncEntry(entry, history);
  }
  
  Future<FoodParseResult> _syncEntry(MealLogEntry entry, List<ChatMessage> history) async {
    AppLogger.d('Starting AI sync for entry: ${entry.id}');
    try {
      final result = await analyzeFoodInput.execute(entry.rawInput, history);
      
      if (result.needsClarification) {
         AppLogger.i('AI sync needs clarification for entry: ${entry.id}');
         await logRepository.deleteMealItem(entry.id);
         return result;
      }

      AppLogger.i('AI sync successful for entry: ${entry.id}. Parsed as: ${result.foodItem?.title}');
      
      final updatedEntry = entry.copyWith(
        syncStatus: SyncStatus.synced,
        foodItem: result.foodItem,
      );
      await logRepository.saveMealItem(updatedEntry);
      return result;
    } catch (e) {
      AppLogger.e('AI sync failed for entry: ${entry.id}', error: e);
      await logRepository.deleteMealItem(entry.id);
      rethrow;
    }
  }
}
