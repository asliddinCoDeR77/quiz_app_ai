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

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
      userAnswer: json['userAnswer'],
    );
  }

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
