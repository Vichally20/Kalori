import 'package:flutter/material.dart';

class FoodIconHelper {
  /// Returns a Record containing the icon, iconColor, and iconBgColor for a given food title.
  static ({IconData icon, Color iconColor, Color iconBgColor}) getIconForFood(String title) {
    const defaultBgColor = Color(0xFFEFF4FF);
    const defaultColor = Color(0xFF0D1C2F);

    // Modern Dart 3 switch expression with pattern matching
    final iconData = switch (title.toLowerCase()) {
      final String s when s.contains('egg') => Icons.egg_alt_outlined,
      final String s when s.contains('coffee') || s.contains('latte') => Icons.coffee_outlined,
      final String s when s.contains('fruit') || s.contains('apple') => Icons.apple,
      final String s when s.contains('pizza') => Icons.local_pizza_outlined,
      final String s when s.contains('avocado') => Icons.eco_outlined,
      _ => Icons.fastfood_outlined,
    };

    // Override color for specific icons
    final iconColor = iconData == Icons.eco_outlined 
        ? const Color(0xFF006C49) 
        : defaultColor;

    return (
      icon: iconData,
      iconColor: iconColor,
      iconBgColor: defaultBgColor,
    );
  }
}
