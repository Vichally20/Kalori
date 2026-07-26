/// Usecase for calculating daily calorie deficit/surplus
class CalculateDeficit {
  double execute({
    required double tdee,
    required double targetCalories,
  }) {
    return tdee - targetCalories;
  }
}
