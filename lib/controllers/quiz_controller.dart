import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:quiz_app/models/quiz_question.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class QuizController {
  final String apiKey;

  QuizController(this.apiKey);

  Future<List<QuizQuestion>> generateQuestions(
    String topic,
    String difficulty,
    int count,
  ) async {
    final prompt = 'Generate $count $difficulty questions about $topic.';

    final model =
        GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: apiKey);
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    if (response.text!.isNotEmpty) {
      final questions = parseResponse(response.text.toString());
      await saveQuestions(questions);
      return questions;
    } else {
      throw Exception('Failed to generate questions');
    }
  }

  List<QuizQuestion> parseResponse(String text) {
    final List<QuizQuestion> questions = [];
    final rawQuestions = text
        .split('\n\n'); // Assuming questions are separated by double newlines

    for (var rawQuestion in rawQuestions) {
      final lines = rawQuestion.split('\n');
      if (lines.length >= 5) {
        questions.add(QuizQuestion(
          id: (questions.length + 1).toString(),
          question: lines[0].trim(),
          options: [
            lines[1].trim(),
            lines[2].trim(),
            lines[3].trim(),
            lines[4].trim(),
          ],
          correctAnswer: lines[1]
              .trim(), // Adjust this if you have a way to determine the correct answer
        ));
      }
    }

    return questions;
  }

  Future<void> saveQuestions(List<QuizQuestion> questions) async {
    final prefs = await SharedPreferences.getInstance();
    final questionsJson = jsonEncode(questions.map((q) => q.toJson()).toList());
    await prefs.setString('quiz_questions', questionsJson);
  }

  Future<List?> loadQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    final questionsJson = prefs.getString('quiz_questions');
    if (questionsJson != null) {
      final List<dynamic> jsonList = jsonDecode(questionsJson);
      return jsonList.map((json) => QuizQuestion.fromJson(json)).toList();
    }
    return null;
  }
}

extension QuizQuestionJson on QuizQuestion {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'userAnswer': userAnswer,
    };
  }
}
