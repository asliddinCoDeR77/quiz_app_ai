import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app/controllers/quiz_controller.dart';
import 'package:quiz_app/models/quiz_question.dart';
import 'feedback_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final String apiKey = 'YOUR_API_KEY';
  String _selectedDifficulty = 'Easy';
  final TextEditingController _topicController = TextEditingController();
  late QuizController _quizController;
  List<QuizQuestion>? _questions;
  int _currentQuestionIndex = 0;
  int _questionCount = 1;
  String? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _quizController = QuizController(apiKey);
  }

  Future<void> _generateQuiz() async {
    if (_topicController.text.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Dialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset('assets/lotties/loading.json'),
                  const Text('Generating Quiz...'),
                ],
              ),
            ),
          );
        },
      );

      try {
        _questions = await _quizController.generateQuestions(
          _topicController.text,
          _selectedDifficulty,
          _questionCount,
        );
        Navigator.of(context).pop();
        setState(() {
          _currentQuestionIndex = 0;
          _selectedAnswer = null;
        });
      } catch (e) {
        Navigator.of(context).pop();
        print('Error: $e');
      }
    }
  }

  void _nextQuestion() {
    if (_selectedAnswer != null) {
      setState(() {
        _questions![_currentQuestionIndex].userAnswer = _selectedAnswer;
        _selectedAnswer = null;

        if (_currentQuestionIndex < _questions!.length - 1) {
          _currentQuestionIndex++;
        } else {
          _showFeedback();
        }
      });
    }
  }

  void _showFeedback() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FeedbackScreen(questions: _questions!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: _topicController,
                decoration: InputDecoration(
                  hintText: 'Enter Topic',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send, color: Colors.orange),
                    onPressed: _generateQuiz,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButton<String>(
                value: _selectedDifficulty,
                items: ['Easy', 'Medium', 'Hard'].map((String difficulty) {
                  return DropdownMenuItem(
                    value: difficulty,
                    child: Text(difficulty),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedDifficulty = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Question Count:'),
                  DropdownButton<int>(
                    value: _questionCount,
                    items: List.generate(50, (index) => index + 1).map((count) {
                      return DropdownMenuItem(
                        value: count,
                        child: Text('$count'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _questionCount = value;
                        });
                      }
                    },
                  ),
                ],
              ),
              const Gap(20),
              if (_questions != null && _questions!.isNotEmpty)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_currentQuestionIndex + 1}. ${_questions![_currentQuestionIndex].question}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ..._questions![_currentQuestionIndex]
                            .options
                            .map((option) {
                          return RadioListTile<String>(
                            title: Text(option),
                            value: option,
                            groupValue: _selectedAnswer,
                            onChanged: (value) {
                              setState(() {
                                _selectedAnswer = value;
                              });
                            },
                          );
                        }).toList(),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(370, 50),
                            backgroundColor: Colors.orange,
                          ),
                          onPressed:
                              _selectedAnswer == null ? null : _nextQuestion,
                          child: const Text(
                            'Next',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (_questions == null)
                const Center(
                  child: Text(
                    'Please enter a topic to start the quiz.',
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
