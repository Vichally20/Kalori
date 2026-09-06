import 'package:get/get.dart';
import 'package:kalori/core/utilities/app_logger.dart';
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

  Future<void> execute(String rawInput) async {
    AppLogger.i('LogMeal execute requested with input: "$rawInput"');
    
    final entry = MealLogEntry(
      id: uuid.v4(),
      rawInput: rawInput,
      syncStatus: SyncStatus.pending,
      createdAt: DateTime.now(),
    );
    await logRepository.saveMealItem(entry);
    AppLogger.d('Saved pending meal entry locally with ID: ${entry.id}');
    
    // Trigger sync asynchronously without waiting for it to finish
    _syncEntry(entry);
  }
  
  Future<void> _syncEntry(MealLogEntry entry) async {
    AppLogger.d('Starting AI sync for entry: ${entry.id}');
    try {
      final foodItem = await analyzeFoodInput.execute(entry.rawInput);
      
      AppLogger.i('AI sync successful for entry: ${entry.id}. Parsed as: ${foodItem.title}');
      
      final updatedEntry = entry.copyWith(
        syncStatus: SyncStatus.synced,
        foodItem: foodItem,
      );
      await logRepository.saveMealItem(updatedEntry);
    } catch (e) {
      AppLogger.e('AI sync failed for entry: ${entry.id}', error: e);
      final failedEntry = entry.copyWith(syncStatus: SyncStatus.failed);
      await logRepository.saveMealItem(failedEntry);
    }
  }
}
