import 'dart:convert';
import 'package:get/get.dart';
import 'package:kalori/core/services/ai_service.dart';
import 'package:kalori/features/log/data/models/food_parse_result_model.dart';
import 'package:kalori/features/log/domain/entities/chat_message.dart';

/// Remote AI Data source interface for Gemini / Cloud AI Parsing
abstract class LogRemoteAISource {
  Future<FoodParseResultModel> parseFoodInput(String query, [List<ChatMessage> history = const []]);
}

/// Implementation of [LogRemoteAISource]
class LogRemoteAISourceImpl implements LogRemoteAISource {
  final AIService aiService = Get.find<AIService>();

  @override
  Future<FoodParseResultModel> parseFoodInput(String query, [List<ChatMessage> history = const []]) async {
    final historyText = history.isEmpty ? '' : 'Conversation History:\n' + history.map((e) => '${e.isUser ? "User" : "AI"}: ${e.text}').join('\n') + '\n\n';
    
    final prompt = '''
You are a helpful nutrition assistant. Evaluate the user's food log input.
If the input lacks portion sizes, cooking methods, or likely missing ingredients (e.g., 'rice and beans' usually has oil or protein), set needs_clarification to true and provide a natural, conversational reply_message asking for details. Do not calculate calories until the user provides enough context.

$historyText
Current Input: "$query"

Expected JSON format:
{
  "needs_clarification": true/false,
  "reply_message": "...",
  "meal_data": {
    "title": "Main food name",
    "subtitle": "Additional details (e.g. quantity)",
    "calories": 250,
    "carbs": 30,
    "protein": 10,
    "fat": 5
  }
}
Return only valid JSON, without any markdown formatting or comments. If needs_clarification is true, meal_data can be null.
''';

    try {
      final response = await aiService.generateContent(prompt);
      final jsonStr = _extractJson(response);
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      
      return FoodParseResultModel.fromMap(map);
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
