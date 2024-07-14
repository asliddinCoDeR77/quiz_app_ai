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
    final lines = text.split('\n');
    final List<QuizQuestion> questions = [];

    for (var i = 0; i < lines.length; i += 5) {
      if (i + 4 < lines.length) {
        questions.add(QuizQuestion(
          id: (questions.length + 1).toString(),
          question: lines[i].trim(),
          options: [
            lines[i + 1].trim(),
            lines[i + 2].trim(),
            lines[i + 3].trim(),
            lines[i + 4].trim(),
          ],
          correctAnswer: lines[i + 1].trim(),
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

  // factory QuizQuestion.fromJson(Map<String, dynamic> json) {
  //   return QuizQuestion(
  //     id: json['id'],
  //     question: json['question'],
  //     options: List<String>.from(json['options']),
  //     correctAnswer: json['correctAnswer'],
  //     userAnswer: json['userAnswer'],
  //   );
  // }
}
