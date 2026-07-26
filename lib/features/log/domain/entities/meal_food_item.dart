/// Entity representing a food item inside the Meal Breakdown card.
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
}
