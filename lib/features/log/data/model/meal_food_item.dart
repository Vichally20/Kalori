/// Data model representing a food item inside the Meal Breakdown card.
class MealFoodItem {
  final String title;
  final String subtitle;
  final String calories;

  const MealFoodItem({
    required this.title,
    required this.subtitle,
    required this.calories,
  });

  MealFoodItem copyWith({
    String? title,
    String? subtitle,
    String? calories,
  }) {
    return MealFoodItem(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      calories: calories ?? this.calories,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'calories': calories,
    };
  }

  factory MealFoodItem.fromMap(Map<String, dynamic> map) {
    return MealFoodItem(
      title: map['title'] as String? ?? '',
      subtitle: map['subtitle'] as String? ?? '',
      calories: map['calories'] as String? ?? '',
    );
  }
}
