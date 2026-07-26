// ignore_for_file: non_const_argument_for_const_parameter

import 'package:flutter/material.dart';
import '../../domain/entities/food_log_item.dart';

/// Data model extending [FoodLogItem] with serialization logic.
class FoodLogItemModel extends FoodLogItem {
  const FoodLogItemModel({
    required super.title,
    required super.subtitle,
    required super.calories,
    required super.icon,
    required super.iconBgColor,
    required super.iconColor,
  });

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

  factory FoodLogItemModel.fromMap(Map<String, dynamic> map) {
    final int codePoint = map['iconCodePoint'] as int? ?? 0xe25a;
    return FoodLogItemModel(
      title: map['title'] as String? ?? '',
      subtitle: map['subtitle'] as String? ?? '',
      calories: map['calories'] as String? ?? '',
      icon: IconData(
        codePoint,
        fontFamily: 'MaterialIcons',
      ),
      iconBgColor: Color(map['iconBgColor'] as int? ?? 0xFFEFF4FF),
      iconColor: Color(map['iconColor'] as int? ?? 0xFF006C49),
    );
  }

  factory FoodLogItemModel.fromEntity(FoodLogItem entity) {
    return FoodLogItemModel(
      title: entity.title,
      subtitle: entity.subtitle,
      calories: entity.calories,
      icon: entity.icon,
      iconBgColor: entity.iconBgColor,
      iconColor: entity.iconColor,
    );
  }
}
