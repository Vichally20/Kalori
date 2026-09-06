import 'package:kalori/features/log/domain/entities/food_item.dart';
import 'package:kalori/features/log/domain/entities/sync_status.dart';

class MealLogEntry {
  final String id;
  final String rawInput;
  final SyncStatus syncStatus;
  final FoodItem? foodItem;
  final DateTime createdAt;

  const MealLogEntry({
    required this.id,
    required this.rawInput,
    required this.syncStatus,
    this.foodItem,
    required this.createdAt,
  });

  MealLogEntry copyWith({
    String? id,
    String? rawInput,
    SyncStatus? syncStatus,
    FoodItem? foodItem,
    DateTime? createdAt,
  }) {
    return MealLogEntry(
      id: id ?? this.id,
      rawInput: rawInput ?? this.rawInput,
      syncStatus: syncStatus ?? this.syncStatus,
      foodItem: foodItem ?? this.foodItem,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
