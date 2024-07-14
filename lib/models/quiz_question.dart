class QuizQuestion {
  String id;
  String question;
  List<String> options;
  String correctAnswer;
  String? userAnswer;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.userAnswer,
  });

  static fromJson(json) {}
}
