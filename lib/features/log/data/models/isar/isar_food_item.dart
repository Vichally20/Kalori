import 'package:isar/isar.dart';
import '../../../domain/entities/food_item.dart';
import '../../../domain/entities/nutritional_info.dart';
import 'isar_nutritional_info.dart';

part 'isar_food_item.g.dart';

@collection
class IsarFoodItem {
  Id id = Isar.autoIncrement;

  String? title;
  String? subtitle;
  DateTime? createdAt;

  IsarNutritionalInfo? nutritionalInfo;

  static IsarFoodItem fromEntity(FoodItem entity) {
    return IsarFoodItem()
      ..title = entity.title
      ..subtitle = entity.subtitle
      ..createdAt = DateTime.now()
      ..nutritionalInfo = (IsarNutritionalInfo()
        ..calories = entity.nutritionalInfo.calories
        ..carbs = entity.nutritionalInfo.carbs
        ..protein = entity.nutritionalInfo.protein
        ..fat = entity.nutritionalInfo.fat);
  }

  FoodItem toEntity() {
    return FoodItem(
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
}