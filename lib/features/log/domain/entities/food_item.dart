import 'nutritional_info.dart';

class FoodItem {
  final String title;
  final String subtitle;
  final NutritionalInfo nutritionalInfo;

  const FoodItem({
    required this.title,
    required this.subtitle,
    required this.nutritionalInfo,
  });

  FoodItem copyWith({
    String? title,
    String? subtitle,
    NutritionalInfo? nutritionalInfo,
  }) {
    return FoodItem(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      nutritionalInfo: nutritionalInfo ?? this.nutritionalInfo,
    );
  }
}
