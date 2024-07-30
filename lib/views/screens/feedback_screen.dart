import 'package:flutter/material.dart';
import 'package:quiz_app/models/quiz_question.dart';

class FeedbackScreen extends StatelessWidget {
  final List<QuizQuestion> questions;

  const FeedbackScreen({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    int correctAnswers = questions
        .where((question) => question.userAnswer == question.correctAnswer)
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You got $correctAnswers out of ${questions.length} correct!',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  return ListTile(
                    title: Text(question.question),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Your answer: ${question.userAnswer}'),
                        Text('Correct answer: ${question.correctAnswer}'),
                      ],
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
