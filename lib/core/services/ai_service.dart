import 'package:get/get.dart';

/// Service wrapper for Gemini SDK / LLM runner integration
class AIService extends GetxService {
  /// Initializes AI service configuration
  Future<AIService> init() async {
    return this;
  }

  /// Sends prompt to AI model and receives response
  Future<String> generateContent(String prompt) async {
    // LLM execution wrapper placeholder
    return 'Parsed response for prompt: $prompt';
  }
}
