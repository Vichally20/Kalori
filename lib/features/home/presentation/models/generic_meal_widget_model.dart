import 'package:flutter/material.dart';

class GenericMealWidgetModel {
  final String title;
  final String subtitle;
  final String trailingText;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;

  const GenericMealWidgetModel({
    required this.title,
    required this.subtitle,
    required this.trailingText,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
  });
}
