import 'package:flutter/material.dart';

/// Entity representing a logged food item or quick entry on the Home Screen.
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
}
