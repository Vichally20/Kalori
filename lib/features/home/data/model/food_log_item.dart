import 'package:flutter/material.dart';

/// Data model representing a logged food item or quick entry on the Home Screen.
class FoodLogItem {
  final String title;
  final String subtitle;
  final String calories;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;

  const FoodLogItem({
    required this.title,
    required this.subtitle,
    required this.calories,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
  });

  FoodLogItem copyWith({
    String? title,
    String? subtitle,
    String? calories,
    IconData? icon,
    Color? iconBgColor,
    Color? iconColor,
  }) {
    return FoodLogItem(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      calories: calories ?? this.calories,
      icon: icon ?? this.icon,
      iconBgColor: iconBgColor ?? this.iconBgColor,
      iconColor: iconColor ?? this.iconColor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'calories': calories,
      'iconCodePoint': icon.codePoint,
      'iconBgColor': iconBgColor.toARGB32(),
      'iconColor': iconColor.toARGB32(),
    };
  }

  factory FoodLogItem.fromMap(Map<String, dynamic> map) {
    return FoodLogItem(
      title: map['title'] as String? ?? '',
      subtitle: map['subtitle'] as String? ?? '',
      calories: map['calories'] as String? ?? '',
      icon: IconData(
        map['iconCodePoint'] as int? ?? Icons.fastfood_outlined.codePoint,
        fontFamily: 'MaterialIcons',
      ),
      iconBgColor: Color(map['iconBgColor'] as int? ?? 0xFFEFF4FF),
      iconColor: Color(map['iconColor'] as int? ?? 0xFF006C49),
    );
  }
}
