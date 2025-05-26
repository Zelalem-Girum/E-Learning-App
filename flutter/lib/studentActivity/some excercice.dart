import 'package:flutter/material.dart';

void main() {
  runApp(PracticeApp());
}

class PracticeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Practice Questions',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PracticeQuestionsPage(),
    );
  }
}

class PracticeQuestionsPage extends StatefulWidget {
  @override
  _PracticeQuestionsPageState createState() => _PracticeQuestionsPageState();
}

class _PracticeQuestionsPageState extends State<PracticeQuestionsPage> {
  final List<Map<String, dynamic>> questions = [
    {
      'type': 'true_false',
      'question': 'The sun rises in the west.',
      'answer': 'False',
    },
    {
      'type': 'multiple_choice',
      'question': 'Which is the smallest prime number?',
      'options': ['0', '1', '2', '3'],
      'answer': '2',
    },
    {
      'type': 'fill_in_the_blank',
      'question': 'The capital of France is _______.',
      'answer': 'Paris',
    },
    {
      'type': 'short_answer',
      'question': 'Name the process by which plants make their food.',
      'answer': 'Photosynthesis',
    },
  ];

  final Map<int, String> userAnswers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Practice Questions')),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: buildQuestionWidget(question, index),
            ),
          );
        },
      ),
    );
  }

  Widget buildQuestionWidget(Map<String, dynamic> question, int index) {
    switch (question['type']) {
      case 'true_false':
        return buildTrueFalseQuestion(question, index);
      case 'multiple_choice':
        return buildMultipleChoiceQuestion(question, index);
      case 'fill_in_the_blank':
        return buildFillInTheBlankQuestion(question, index);
      case 'short_answer':
        return buildShortAnswerQuestion(question, index);
      default:
        return Text('Unknown question type');
    }
  }

  Widget buildTrueFalseQuestion(Map<String, dynamic> question, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question['question'],
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                checkAnswer(index, 'True', question['answer']);
              },
              child: Text('True'),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                checkAnswer(index, 'False', question['answer']);
              },
              child: Text('False'),
            ),
          ],
        ),
        if (userAnswers.containsKey(index)) ...[
          SizedBox(height: 10),
          Text(
            'Your answer: ${userAnswers[index]}',
            style: TextStyle(color: Colors.blue),
          ),
        ],
      ],
    );
  }

  Widget buildMultipleChoiceQuestion(Map<String, dynamic> question, int index) {
    List<String> options = List<String>.from(question['options']);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question['question'],
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ...options.map(
          (option) => ListTile(
            title: Text(option),
            leading: Radio<String>(
              value: option,
              groupValue: userAnswers[index],
              onChanged: (value) {
                setState(() {
                  userAnswers[index] = value!;
                });
                checkAnswer(index, value!, question['answer']);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildFillInTheBlankQuestion(Map<String, dynamic> question, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question['question'],
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextField(
          onSubmitted: (value) {
            checkAnswer(index, value, question['answer']);
          },
          decoration: InputDecoration(hintText: 'Type your answer...'),
        ),
        if (userAnswers.containsKey(index)) ...[
          SizedBox(height: 10),
          Text(
            'Your answer: ${userAnswers[index]}',
            style: TextStyle(color: Colors.blue),
          ),
        ],
      ],
    );
  }

  Widget buildShortAnswerQuestion(Map<String, dynamic> question, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question['question'],
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextField(
          onSubmitted: (value) {
            checkAnswer(index, value, question['answer']);
          },
          decoration: InputDecoration(hintText: 'Write a short answer...'),
        ),
        if (userAnswers.containsKey(index)) ...[
          SizedBox(height: 10),
          Text(
            'Your answer: ${userAnswers[index]}',
            style: TextStyle(color: Colors.blue),
          ),
        ],
      ],
    );
  }

  void checkAnswer(int index, String userAnswer, String correctAnswer) {
    setState(() {
      userAnswers[index] = userAnswer;
    });
    if (userAnswer.trim().toLowerCase() == correctAnswer.trim().toLowerCase()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Correct!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Wrong! Correct answer: $correctAnswer')),
      );
    }
  }
}
