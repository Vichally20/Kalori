/// Usecase for calculating Total Daily Energy Expenditure (TDEE)
class CalculateTDEE {
  double execute({
    required double weightKg,
    required double heightCm,
    required int age,
    required bool isMale,
    required double activityMultiplier,
  }) {
    // Mifflin-St Jeor Equation
    double bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age);
    bmr += isMale ? 5 : -161;
    return bmr * activityMultiplier;
  }
}
