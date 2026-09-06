import 'package:kalori/features/log/domain/entities/meal_log_entry.dart';
import 'package:kalori/features/log/domain/entities/sync_status.dart';
import 'package:kalori/features/log/data/models/food_item_model.dart';

class MealLogEntryModel extends MealLogEntry {
  const MealLogEntryModel({
    required super.id,
    required super.rawInput,
    required super.syncStatus,
    super.foodItem,
    required super.createdAt,
  });

  factory MealLogEntryModel.fromEntity(MealLogEntry entity) {
    return MealLogEntryModel(
      id: entity.id,
      rawInput: entity.rawInput,
      syncStatus: entity.syncStatus,
      foodItem: entity.foodItem,
      createdAt: entity.createdAt,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rawInput': rawInput,
      'syncStatus': syncStatus.index,
      'foodItem': foodItem != null ? FoodItemModel.fromEntity(foodItem!).toMap() : null,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
