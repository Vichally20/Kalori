import '../../domain/entities/meal_food_item.dart';

/// Data model extending [MealFoodItem] with serialization logic.
class MealFoodItemModel extends MealFoodItem {
  const MealFoodItemModel({
    required super.title,
    required super.subtitle,
    required super.calories,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'calories': calories,
    };
  }

  factory MealFoodItemModel.fromMap(Map<String, dynamic> map) {
    return MealFoodItemModel(
      title: map['title'] as String? ?? '',
      subtitle: map['subtitle'] as String? ?? '',
      calories: map['calories'] as String? ?? '',
    );
  }

  factory MealFoodItemModel.fromEntity(MealFoodItem entity) {
    return MealFoodItemModel(
      title: entity.title,
      subtitle: entity.subtitle,
      calories: entity.calories,
    );
  }
}
