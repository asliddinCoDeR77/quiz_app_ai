import 'package:flutter/material.dart';
import 'package:quiz_app/models/quiz_question.dart';

class FeedbackScreen extends StatelessWidget {
  final List<QuizQuestion> questions;

  const FeedbackScreen({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    int correctAnswers = 0;

    for (var question in questions) {
      if (question.userAnswer == question.correctAnswer) {
        correctAnswers++;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Feedback')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'You answered $correctAnswers out of ${questions.length} correctly!'),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${index + 1}. ${question.question}'),
                          const SizedBox(height: 10),
                          for (var option in question.options)
                            Text(option,
                                style: TextStyle(
                                  fontWeight: option == question.correctAnswer
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: option == question.userAnswer
                                      ? Colors.blue
                                      : Colors.black,
                                )),
                          if (question.userAnswer != question.correctAnswer)
                            Text('Your answer: ${question.userAnswer}',
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold)),
                          if (question.userAnswer == question.correctAnswer)
                            const Text('Correct!',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
