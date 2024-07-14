import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/quiz_question.dart';

class QuizController {
  final String apiKey;

  QuizController(this.apiKey);

  Future<List<QuizQuestion>> generateQuestions(
      String topic, String difficulty, int count) async {
    final prompt = 'Generate $count $difficulty questions about $topic.';

    final model =
        GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: apiKey);
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    if (response.text!.isNotEmpty) {
      return parseResponse(response.text.toString());
    } else {
      throw Exception('Failed to generate questions');
    }
  }

  List<QuizQuestion> parseResponse(String text) {
    final lines = text.split('\n');
    final List<QuizQuestion> questions = [];

    for (var i = 0; i < lines.length; i += 5) {
      if (i + 4 < lines.length) {
        questions.add(QuizQuestion(
          id: (questions.length + 1).toString(),
          question: lines[i].trim(),
          options: [
            lines[i + 1].trim(), // Option A
            lines[i + 2].trim(), // Option B
            lines[i + 3].trim(), // Option C
            lines[i + 4].trim(), // Option D
          ],
          correctAnswer:
              lines[i + 1].trim(), // Assuming the first option is correct
        ));
      }
    }

    return questions;
  }
}
