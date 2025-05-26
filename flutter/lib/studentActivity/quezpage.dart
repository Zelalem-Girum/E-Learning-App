import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:v1/models/qize.dart';
import 'package:v1/studentActivity/appbar.dart';

class InteractiveQuizzesPage extends StatefulWidget {
  const InteractiveQuizzesPage({super.key});

  @override
  _InteractiveQuizzesPageState createState() => _InteractiveQuizzesPageState();
}

class _InteractiveQuizzesPageState extends State<InteractiveQuizzesPage> {
  final List<Quiz> trueFalseQuestions = [];
  final List<Quiz> multipleChoiceQuestions = [];
  final List<Quiz> blankSpaceQuestions = [];
  Map<int, String> trueFalseAnswers = {};
  Map<int, String> multipleChoiceAnswers = {};
  Map<int, TextEditingController> blankSpaceControllers = {};
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchQuiz();
  }

  Future<void> fetchQuiz() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Fetch true/false questions
      final trueFalseResponse = await http.get(
        Uri.parse('http://localhost:8800/quize/truefalse'),
      );
      if (trueFalseResponse.statusCode == 200) {
        List<dynamic> data = jsonDecode(trueFalseResponse.body);
        setState(() {
          trueFalseQuestions.clear();
          trueFalseQuestions.addAll(
            data.map((json) => Quiz.fromJson(json)).toList(),
          );
        });
      } else {
        throw Exception(
          'Failed to load true/false questions: ${trueFalseResponse.statusCode}',
        );
      }

      // Fetch multiple-choice questions
      final multipleChoiceResponse = await http.get(
        Uri.parse('http://localhost:8800/quize/multiple'),
      );
      if (multipleChoiceResponse.statusCode == 200) {
        List<dynamic> data = jsonDecode(multipleChoiceResponse.body);
        setState(() {
          multipleChoiceQuestions.clear();
          multipleChoiceQuestions.addAll(
            data.map((json) => Quiz.fromJson(json)).toList(),
          );
        });
      } else {
        throw Exception(
          'Failed to load multiple-choice questions: ${multipleChoiceResponse.statusCode}',
        );
      }

      // Fetch blank space questions
      final blankSpaceResponse = await http.get(
        Uri.parse('http://localhost:8800/quize/blanckspace'),
      );
      if (blankSpaceResponse.statusCode == 200) {
        List<dynamic> data = jsonDecode(blankSpaceResponse.body);
        setState(() {
          blankSpaceQuestions.clear();
          blankSpaceQuestions.addAll(
            data.map((json) => Quiz.fromJson(json)).toList(),
          );
          // Initialize controllers for blank space questions
          for (var i = 0; i < blankSpaceQuestions.length; i++) {
            blankSpaceControllers[i] = TextEditingController();
          }
        });
      } else {
        throw Exception(
          'Failed to load blank space questions: ${blankSpaceResponse.statusCode}',
        );
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching quizzes: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // Dispose of all TextEditingControllers
    blankSpaceControllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TopBare(), // Assuming TopBar is correctly defined
                    const Text(
                      '🧠 True or False',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    if (trueFalseQuestions.isEmpty)
                      const Text('No true/false questions available.')
                    else
                      ...trueFalseQuestions.asMap().entries.map(
                        (entry) => Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(entry.value.question),
                            subtitle: Row(
                              children:
                                  ['True', 'False'].map((option) {
                                    return Expanded(
                                      child: RadioListTile<String>(
                                        title: Text(option),
                                        value: option,
                                        groupValue: trueFalseAnswers[entry.key],
                                        onChanged: (value) {
                                          setState(() {
                                            trueFalseAnswers[entry.key] =
                                                value!;
                                          });
                                        },
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    const Text(
                      '📚 Multiple Choice',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    if (multipleChoiceQuestions.isEmpty)
                      const Text('No multiple-choice questions available.')
                    else
                      ...multipleChoiceQuestions.asMap().entries.map(
                        (entry) => Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  entry.value.question,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              ...entry.value.options.map<Widget>((choice) {
                                return RadioListTile<String>(
                                  title: Text(choice),
                                  value: choice,
                                  groupValue: multipleChoiceAnswers[entry.key],
                                  onChanged: (value) {
                                    setState(() {
                                      multipleChoiceAnswers[entry.key] = value!;
                                    });
                                  },
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    const Text(
                      '📝 Blank Space',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    if (blankSpaceQuestions.isEmpty)
                      const Text('No blank space questions available.')
                    else
                      ...blankSpaceQuestions.asMap().entries.map(
                        (entry) => Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: TextField(
                                    controller:
                                        blankSpaceControllers[entry.key],
                                    decoration: const InputDecoration(
                                      labelText: 'Your answer',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    entry.value.question,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        onPressed: checkAnswers,
                        child: const Text('Submit Quiz'),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  void checkAnswers() {
    int trueFalseCorrect = 0;
    int multipleChoiceCorrect = 0;
    int blankSpaceCorrect = 0;

    // Check true/false answers
    for (var i = 0; i < trueFalseQuestions.length; i++) {
      if (trueFalseAnswers[i] == trueFalseQuestions[i].answer) {
        trueFalseCorrect++;
      }
    }

    // Check multiple-choice answers
    for (var i = 0; i < multipleChoiceQuestions.length; i++) {
      if (multipleChoiceAnswers[i] == multipleChoiceQuestions[i].answer) {
        multipleChoiceCorrect++;
      }
    }

    // Check blank space answers
    for (var i = 0; i < blankSpaceQuestions.length; i++) {
      if (blankSpaceControllers[i]?.text.trim() ==
          blankSpaceQuestions[i].answer) {
        blankSpaceCorrect++;
      }
    }

    final message = '''
Results:
- True/False: $trueFalseCorrect/${trueFalseQuestions.length} correct
- Multiple Choice: $multipleChoiceCorrect/${multipleChoiceQuestions.length} correct
- Blank Space: $blankSpaceCorrect/${blankSpaceQuestions.length} correct
''';

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Quiz Results'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}


            // Section 2: Multiple Choice
            // Text('📚 Blanck Space', style: sectionTitle()),
            // ...blanckspaceQuestions.map(
            //   (q) => Card(
            //     margin: EdgeInsets.symmetric(vertical: 8),
            //     child: Row(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         SizedBox(
            //           width: 200,
            //           child: Padding(
            //             padding: EdgeInsets.all(12),
            //             child: TextField(),
            //           ),
            //         ),
            //         Padding(
            //           padding: EdgeInsets.all(12),
            //           child: Text(q.question, style: TextStyle(fontSize: 16)),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            // SizedBox(height: 30),

           