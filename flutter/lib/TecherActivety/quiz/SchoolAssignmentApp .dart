import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v1/TecherActivety/appbar.dart' show TopBare;
import 'package:v1/models/assigment.dart';

// Quiz List Page
class CreateAssignmentPage extends StatefulWidget {
  @override
  _CreateAssignmentPageState createState() => _CreateAssignmentPageState();
}

class _CreateAssignmentPageState extends State<CreateAssignmentPage> {
  late int sid = 0;
  @override
  void initState() {
    super.initState();
    tast();
  }

  void tast() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // print("Subject id: ${prefs.getInt("sid")}");
      sid = prefs.getInt("sid")!;
    });
    fetchAssignments();
  }

  bool isloding = true;
  List<Assignment> assignments = [];
  Future<void> fetchAssignments() async {
    // print(sid);
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8800/assignments/$sid'),
      );
      // print("hello");
      if (response.statusCode == 200) {
        // Parse the JSON response
        List<dynamic> data = jsonDecode(response.body);
        var lists = data.map((json) => Assignment.fromJson(json)).toList();
        // print(response.body);
        setState(() {
          isloding = false;
          assignments.addAll(lists);
          // for (Quiz q in lists) print(q.printer());
        });
      }
      // print("length of quize =${quizzes.length}");
    } catch (e) {
      print(e);
    }
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
                  Uri.parse('http://localhost:8800/assignments/$id'),
                );
                if (response.statusCode == 200 || response.statusCode == 201) {
                  message = "RECORD DELETED SUCCESSFULLY";
                  print(response.body);
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
                          builder: (context) => AddOrEditQuizPage(),
                        ),
                      ).then((value) {
                        setState(() {});
                      });
                    },
                  ),
                  assignments.isEmpty
                      ? Center(child: Text('No quizzes yet. Add one!'))
                      : Expanded(
                        child: ListView.builder(
                          itemCount: assignments.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Text(assignments[index].title),
                                subtitle: Text(
                                  '''Due Date: ${assignments[index].created_at}
Due Date: ${assignments[index].dueDate}
                                  ''',
                                ),
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
                                                  assignment:
                                                      assignments[index],
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
                                            assignments[index].id,
                                            context,
                                          );
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder:
                                  //         (context) => PlayQuizPage(
                                  //           quiz: assi[index],
                                  //         ),
                                  //   ),
                                  // );
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
  final Assignment? assignment;
  AddOrEditQuizPage({this.assignment});

  @override
  _AddOrEditQuizPageState createState() => _AddOrEditQuizPageState();
}

class _AddOrEditQuizPageState extends State<AddOrEditQuizPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController dc = TextEditingController();
  TextEditingController tc = TextEditingController();
  String title = '';
  String description = '';
  bool isSave = false;
  DateTime? dueDate;
  late int sid;

  List<Assignment> assignments = [];
  @override
  void initState() {
    super.initState();

    if (widget.assignment != null) {
      tc.text = widget.assignment!.title;
      dc.text = widget.assignment!.description;
      dueDate = widget.assignment!.dueDate;
      isedit = true;
    }

    tast();
  }

  void tast() async {
    final prefs = await SharedPreferences.getInstance();
    // print("Subject id: ${prefs.getInt("sid")}");
    sid = prefs.getInt("sid")!;
  }

  bool isedit = false;
  late int id;
  var baseUrl = "http://localhost:8800/assignments";
  Future<void> submitAssignment() async {
    try {
      if (_formKey.currentState!.validate() && dueDate != null) {
        _formKey.currentState!.save();

        final newAssignment = Assignment(
          id: 0,
          title: title,
          description: description,
          subject: sid ?? 0,
          dueDate: dueDate!,
          created_at: dueDate!,
        );

        // print('$baseUrl/${widget.assignment!.id}');
        // print(newAssignment.created_at);
        final response =
            isedit
                ? await http.put(
                  Uri.parse('$baseUrl/${widget.assignment!.id}'),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode(newAssignment.toJson()),
                )
                : await http.post(
                  Uri.parse(baseUrl),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode(newAssignment.toJson()),
                );
        if (response.statusCode == 200 || response.statusCode == 201) {
          print(response.body);
        } else {
          print(
            'Failed to insert data: ${response.statusCode} - ${response.body}',
          );
        }
        setState(() {
          isSave = true;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Assignment Created')));

        _formKey.currentState!.reset();
        dueDate = null;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isSave
        ? CreateAssignmentPage()
        : Scaffold(
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: tc,
                    decoration: InputDecoration(labelText: 'Title'),
                    validator:
                        (val) =>
                            val == null || val.isEmpty ? 'Enter title' : null,
                    onSaved: (val) => title = val ?? '',
                  ),

                  TextFormField(
                    // controller: dc,
                    decoration: InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    validator:
                        (val) =>
                            val == null || val.isEmpty
                                ? 'Enter description'
                                : null,
                    onSaved: (val) => description = val ?? '',
                  ),
                  SizedBox(height: 16),
                  ListTile(
                    title: Text(
                      dueDate == null
                          ? 'Select Due Date'
                          : 'Due Date: ${dueDate!.toLocal().toString().split(' ')[0]}',
                    ),
                    trailing: Icon(Icons.calendar_today),
                    onTap: pickDueDate,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: submitAssignment,
                    child: Text('Create Assignment'),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Created Assignments:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...assignments.map(
                    (a) => ListTile(
                      title: Text(a.title),
                      subtitle: Text(
                        '${a.subject} - Due: ${a.dueDate.toLocal().toString().split(' ')[0]}',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
  }
} // Play Quiz Page
