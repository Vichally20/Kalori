import 'dart:convert';
import 'package:get/get.dart';
import 'package:kalori/core/services/ai_service.dart';
import 'package:kalori/features/log/data/models/food_item_model.dart';
import 'package:kalori/features/log/domain/entities/nutritional_info.dart';

/// Remote AI Data source interface for Gemini / Cloud AI Parsing
abstract class LogRemoteAISource {
  Future<FoodItemModel> parseFoodInput(String query);
}

/// Implementation of [LogRemoteAISource]
class LogRemoteAISourceImpl implements LogRemoteAISource {
  final AIService aiService = Get.find<AIService>();

  @override
  Future<FoodItemModel> parseFoodInput(String query) async {
    final prompt = '''
Analyze the following food input and return a JSON object with the nutritional breakdown.
Input: "$query"
Expected JSON format:
{
  "title": "Main food name",
  "subtitle": "Additional details (e.g. quantity)",
  "calories": 250,
  "carbs": 30,
  "protein": 10,
  "fat": 5
}
Return only valid JSON, without any markdown formatting or comments.
''';

    try {
      final response = await aiService.generateContent(prompt);
      final jsonStr = _extractJson(response);
      final map = jsonDecode(jsonStr);
      
      return FoodItemModel(
        title: map['title']?.toString() ?? 'Unknown',
        subtitle: map['subtitle']?.toString() ?? '',
        nutritionalInfo: NutritionalInfo(
          calories: _parseInt(map['calories']),
          carbs: _parseInt(map['carbs']),
          protein: _parseInt(map['protein']),
          fat: _parseInt(map['fat']),
        ),
      );
    } catch (e) {
      throw Exception('Failed to parse food: $e');
    }
  }

  String _extractJson(String response) {
    final startIndex = response.indexOf('{');
    final endIndex = response.lastIndexOf('}');
    if (startIndex != -1 && endIndex != -1) {
      return response.substring(startIndex, endIndex + 1);
    }
    return response;
  }
  
  int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
