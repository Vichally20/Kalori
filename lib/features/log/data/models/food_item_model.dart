import '../../domain/entities/food_item.dart';
import '../../domain/entities/nutritional_info.dart';

/// Data model extending [FoodItem] with serialization logic.
class FoodItemModel extends FoodItem {
  const FoodItemModel({
    required super.title,
    required super.subtitle,
    required super.nutritionalInfo,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'calories': nutritionalInfo.calories,
      'carbs': nutritionalInfo.carbs,
      'protein': nutritionalInfo.protein,
      'fat': nutritionalInfo.fat,
    };
  }

  factory FoodItemModel.fromMap(Map<String, dynamic> map) {
    return FoodItemModel(
      title: map['title'] as String? ?? '',
      subtitle: map['subtitle'] as String? ?? '',
      nutritionalInfo: NutritionalInfo(
        calories: _parseInt(map['calories']),
        carbs: _parseInt(map['carbs']),
        protein: _parseInt(map['protein']),
        fat: _parseInt(map['fat']),
      ),
    );
  }

  factory FoodItemModel.fromEntity(FoodItem entity) {
    return FoodItemModel(
      title: entity.title,
      subtitle: entity.subtitle,
      nutritionalInfo: entity.nutritionalInfo,
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) {
      final match = RegExp(r'\d+').firstMatch(value);
      if (match != null) {
        return int.tryParse(match.group(0) ?? '0') ?? 0;
      }
    }
    return 0;
  }
}
