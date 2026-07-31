class NutritionalInfo {
  final int calories;
  final int carbs;
  final int protein;
  final int fat;

  const NutritionalInfo({
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
  });

  NutritionalInfo copyWith({
    int? calories,
    int? carbs,
    int? protein,
    int? fat,
  }) {
    return NutritionalInfo(
      calories: calories ?? this.calories,
      carbs: carbs ?? this.carbs,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
    );
  }
}
