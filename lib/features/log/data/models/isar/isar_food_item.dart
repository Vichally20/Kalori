import 'package:isar/isar.dart';
import 'package:kalori/features/log/data/models/isar/isar_nutritional_info.dart';
import 'package:kalori/features/log/domain/entities/food_item.dart';
import 'package:kalori/features/log/domain/entities/nutritional_info.dart';
import 'package:kalori/features/log/domain/entities/meal_log_entry.dart';
import 'package:kalori/features/log/domain/entities/sync_status.dart';

part 'isar_food_item.g.dart';

@collection
class IsarFoodItem {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? uuid;

  String? rawInput;

  @enumerated
  SyncStatus syncStatus = SyncStatus.pending;

  String? title;
  String? subtitle;
  DateTime? createdAt;

  IsarNutritionalInfo? nutritionalInfo;

  static IsarFoodItem fromMealLogEntry(MealLogEntry entry) {
    return IsarFoodItem()
      ..uuid = entry.id
      ..rawInput = entry.rawInput
      ..syncStatus = entry.syncStatus
      ..title = entry.foodItem?.title
      ..subtitle = entry.foodItem?.subtitle
      ..createdAt = entry.createdAt
      ..nutritionalInfo = entry.foodItem != null ? (IsarNutritionalInfo()
        ..calories = entry.foodItem!.nutritionalInfo.calories
        ..carbs = entry.foodItem!.nutritionalInfo.carbs
        ..protein = entry.foodItem!.nutritionalInfo.protein
        ..fat = entry.foodItem!.nutritionalInfo.fat) : null;
  }

  MealLogEntry toMealLogEntry() {
    FoodItem? foodItem;
    if (title != null && title!.isNotEmpty) {
      foodItem = FoodItem(
        title: title ?? '',
        subtitle: subtitle ?? '',
        nutritionalInfo: NutritionalInfo(
          calories: nutritionalInfo?.calories ?? 0,
          carbs: nutritionalInfo?.carbs ?? 0,
          protein: nutritionalInfo?.protein ?? 0,
          fat: nutritionalInfo?.fat ?? 0,
        ),
      );
    }

    return MealLogEntry(
      id: uuid ?? '',
      rawInput: rawInput ?? '',
      syncStatus: syncStatus,
      foodItem: foodItem,
      createdAt: createdAt ?? DateTime.now(),
    );
  }
}