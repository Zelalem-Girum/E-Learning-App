import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v1/models/qize.dart';
import 'package:v1/TecherActivety/appbar.dart';

// Global Quiz List
List<Quiz> quizzes = [];

enum TrueFalse { True, False }

// Quiz List Page
class QuizListPage extends StatefulWidget {
  @override
  _QuizListPageState createState() => _QuizListPageState();
}

class _QuizListPageState extends State<QuizListPage> {
  @override
  void initState() {
    super.initState();
    fetchSubjects();
    tast();
  }

  late int sid;
  void tast() async {
    final prefs = await SharedPreferences.getInstance();
    // print("Subject id: ${prefs.getInt("sid")}");
    sid = prefs.getInt("sid")!;
  }

  bool isloding = true;

  Future<void> fetchSubjects() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8800/quize'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        var lists = data.map((json) => Quiz.fromJson(json)).toList();
        // print(lists.length);
        setState(() {
          isloding = false;
          quizzes.addAll(lists);
          // for (Quiz q in lists) print(q.printer());
        });
      }
      // print("length of quize =${quizzes.length}");
    } catch (e) {}
    // print(quizzes.length);
  }

  void deletQuize(int id, BuildContext context) async {
    String message = "";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 10),
              Text('Confirm Delete'),
            ],
          ),
          content: Text('Are you sure you want to delete this quiz?'),
          actions: [
            TextButton(
              child: Text('No', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop(); // close dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Yes'),
              onPressed: () async {
                final response = await http.delete(
                  Uri.parse('http://localhost:8800/quize/$id'),
                );
                if (response.statusCode == 200 || response.statusCode == 201) {
                  message = "RECORD DELETED SUCCESSFULLY";
                  print("RECORD DELETED");
                } else {
                  message = "RECORD NOT DELETED";
                }

                Navigator.of(context).pop(); // close dialog
              },
            ),
          ],
        );
      },
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$message'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 122, 222, 233),
      body:
          isloding
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  TopBare(),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddOrEditQuizPage(id: sid),
                        ),
                      ).then((value) {
                        setState(() {});
                      });
                    },
                  ),
                  quizzes.isEmpty
                      ? Center(child: Text('No quizzes yet. Add one!'))
                      : Expanded(
                        child: ListView.builder(
                          itemCount: quizzes.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Text(quizzes[index].question),
                                subtitle: Text('Type: ${quizzes[index].type}'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => AddOrEditQuizPage(
                                                  quiz: quizzes[index],
                                                  id: sid,
                                                ),
                                          ),
                                        ).then((value) {
                                          setState(() {});
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          deletQuize(
                                            quizzes[index].id,
                                            context,
                                          );
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => PlayQuizPage(
                                            quiz: quizzes[index],
                                          ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                ],
              ),
    );
  }
}

class AddOrEditQuizPage extends StatefulWidget {
  final Quiz? quiz;
  int id;
  AddOrEditQuizPage({this.quiz, required this.id});

  @override
  _AddOrEditQuizPageState createState() => _AddOrEditQuizPageState();
}

class _AddOrEditQuizPageState extends State<AddOrEditQuizPage> {
  TrueFalse? anser;
  final _formKey = GlobalKey<FormState>();
  String selectedType = 'truefalse';
  TextEditingController questionController = TextEditingController();
  TextEditingController optionControllers = TextEditingController();

  TextEditingController answerController = TextEditingController();
  bool ised = false;
  bool isback = false;
  @override
  void initState() {
    super.initState();

    print(widget.id);
    if (widget.quiz != null) {
      print(widget.quiz!.question);
      questionController.text = widget.quiz!.question;
      widget.quiz!.type == "truefalse"
          ? anser =
              (widget.quiz!.answer == "True" ? TrueFalse.True : TrueFalse.False)
          : answerController.text = widget.quiz!.answer;
      setState(() {
        ised = true;
      });
      // print("Subject : ${widget.quiz!.subject}");
    }
  }

  @override
  void dispose() {
    questionController.dispose();
    answerController.dispose();
    optionControllers.dispose();
    super.dispose();
  }

  void saveQuiz() async {
    // print("hello $ised");
    if (_formKey.currentState!.validate()) {
      Quiz newQuiz = Quiz(
        id: widget.quiz?.id ?? Random().nextInt(10000),
        type: selectedType,
        question: questionController.text,
        options:
            selectedType == 'multiple' ? optionControllers.text.split(",") : [],
        answer:
            (selectedType == "truefalse")
                ? (anser == TrueFalse.True ? "True" : "False")
                : answerController.text,
        subject: widget.id,
      );
      print(newQuiz.printer());
      print(newQuiz.subject);
      final response =
          ised
              ? await http.put(
                Uri.parse('http://localhost:8800/quize/${widget.quiz!.id}'),
                headers: {
                  'Content-Type':
                      'application/json', // Tell the server we're sending JSON
                },
                body: jsonEncode(
                  newQuiz.toJson(),
                ), // Convert quiz to JSON string
              )
              : await http.post(
                Uri.parse('http://localhost:8800/quize/'),
                headers: {
                  'Content-Type':
                      'application/json', // Tell the server we're sending JSON
                },
                body: jsonEncode(
                  newQuiz.toJson(),
                ), // Convert quiz to JSON string
              );
      //  print(response.statusCode);

      if (response.statusCode == 201 || response.statusCode == 200) {
        print(ised ? "Data Edited sucessfully" : 'Link inserted successfully!');
      } else {
        print(
          'Failed to insert link: ${response.statusCode} - ${response.body}',
        );
      }
      setState(() {
        if (widget.quiz != null) {
          int index = quizzes.indexWhere((q) => q.id == widget.quiz!.id);
          quizzes[index] = newQuiz;
        } else {
          quizzes.add(newQuiz);
        }
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isback
        ? QuizListPage()
        : Scaffold(
          backgroundColor: const Color.fromARGB(255, 122, 222, 233),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TopBare(),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          setState(() {
                            isback = true;
                          });
                        },
                        color: const Color.fromARGB(255, 102, 83, 248),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () {},
                        color: const Color.fromARGB(255, 102, 83, 248),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () {},
                        color: const Color.fromARGB(255, 102, 83, 248),
                      ),
                    ],
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    decoration: InputDecoration(labelText: 'Quiz Type'),
                    items: [
                      DropdownMenuItem(
                        value: 'truefalse',
                        child: Text('True/False'),
                      ),
                      DropdownMenuItem(
                        value: 'multiple',
                        child: Text('Multiple Choice'),
                      ),
                      DropdownMenuItem(
                        value: 'blanckspace',
                        child: Text(
                          'Blank Space',
                        ), // Corrected typo: "blanck" to "blank"
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedType = value!;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    controller: questionController,
                    maxLines: 5,
                    decoration: InputDecoration(labelText: 'Question'),
                    validator:
                        (value) => value!.isEmpty ? 'Enter question' : null,
                  ),
                  SizedBox(height: 10),
                  if (selectedType == 'multiple')
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      controller: optionControllers,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'choise option  by using coma separation ',
                      ),
                      validator:
                          (value) => value!.isEmpty ? 'Enter option' : null,
                    ),

                  SizedBox(height: 10),
                  selectedType == "truefalse"
                      ? Column(
                        children: [
                          ListTile(
                            title: const Text('True'),
                            leading: Radio<TrueFalse>(
                              value: TrueFalse.True,
                              groupValue: anser,
                              onChanged: (TrueFalse? value) {
                                setState(() {
                                  anser = value;
                                  print(value);
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('False'),
                            leading: Radio<TrueFalse>(
                              value: TrueFalse.False,
                              groupValue: anser,
                              onChanged: (TrueFalse? value) {
                                setState(() {
                                  anser = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      )
                      : TextFormField(
                        controller: answerController,
                        decoration: InputDecoration(labelText: 'Answer'),
                        validator:
                            (value) => value!.isEmpty ? 'Enter answer' : null,
                      ),

                  SizedBox(height: 20),
                  ElevatedButton(onPressed: saveQuiz, child: Text('Save Quiz')),
                ],
              ),
            ),
          ),
        );
  }
} // Play Quiz Page

class PlayQuizPage extends StatelessWidget {
  final Quiz quiz;

  PlayQuizPage({required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Play Quiz')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quiz.question,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            if (quiz.type == 'truefalse')
              Column(
                children:
                    ['True', 'False'].map((choice) {
                      return ListTile(
                        title: Text(choice),
                        leading: Radio<String>(
                          value: choice,
                          groupValue: null,
                          onChanged: (value) {
                            _showResult(context, value == quiz.answer);
                          },
                        ),
                      );
                    }).toList(),
              ),
            if (quiz.type == 'multiple')
              Column(
                children:
                    quiz.options.map((option) {
                      return ListTile(
                        title: Text(option),
                        leading: Radio<String>(
                          value: option,
                          groupValue: null,
                          onChanged: (value) {
                            _showResult(context, value == quiz.answer);
                          },
                        ),
                      );
                    }).toList(),
              ),
            if (quiz.type == 'matching')
              Column(
                children:
                    quiz.options.map((option) {
                      return ListTile(
                        title: Text(option),
                        subtitle: Text('Match it with: ${quiz.answer}'),
                      );
                    }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  void _showResult(BuildContext context, bool isCorrect) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(isCorrect ? 'Correct 🎉' : 'Wrong ❌'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }
}
