import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String _apiKey = 'AIzaSyDjMRis8O8kpf0TQkGq3Kgc3eJxqzA7nvM';
  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-3-flash-preview', 
      apiKey: _apiKey,
    );
  }

  Future<String> getResponse(String userQuestion, Map<String, dynamic> ecosystemState) async {
    final prompt = '''
    You are a friendly, educational marine biologist assistant for a kids' game called "Turtle Hero".
    
    Current Ecosystem State:
    - Pollution Level: ${(ecosystemState['pollution'] as double).toStringAsFixed(2)} (0.0 is clean, 1.0 is very polluted)
    - Fish Count: ${ecosystemState['fishCount']}
    - Seaweed Count: ${ecosystemState['seaweedCount']}
    
    Context:
    The user is playing a simulation level where they control these parameters.
    Your goal is to explain how these parameters affect the ecosystem in simple, child-friendly observations.
    Emphasize balance. If pollution is high (>0.5), warn them gently. If seaweed is low, explain fish need food/oxygen.
    
    User Question: "$userQuestion"
    
    Keep the answer short (max 2-3 sentences), fun, and educational. Answer in Arabic as the game UI is in Arabic.
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'أنا هنا لمساعدتك في فهم المحيط! حاول مرة أخرى.';
    } catch (e) {
      return 'عذراً، لا أستطيع الاتصال بقاعدة البيانات البحرية حالياً. (Error: $e)';
    }
  }
}
