import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kalori/core/utilities/app_logger.dart';

/// Service wrapper for Gemini SDK / LLM runner integration
class AIService extends GetxService {
  late final GenerativeModel _model;

  /// Initializes AI service configuration
  Future<AIService> init() async {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
    );
    AppLogger.d('AIService initialized');
    return this;
  }

  /// Sends prompt to AI model and receives response
  Future<String> generateContent(String prompt) async {
    try {
      AppLogger.d('AIService generating content...');
      final response = await _model.generateContent([Content.text(prompt)]);
      AppLogger.d('AIService response received');
      return response.text ?? '';
    } catch (e) {
      AppLogger.e('AIService failed to generate content', error: e);
      throw Exception('Failed to generate content: $e');
    }
  }
}

