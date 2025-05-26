import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:v1/TecherActivety/appbar.dart';
import 'package:v1/models/subject.dart';

class SubjectRegistrationPage extends StatefulWidget {
  @override
  _SubjectRegistrationPageState createState() =>
      _SubjectRegistrationPageState();
}

class _SubjectRegistrationPageState extends State<SubjectRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  var baseUrl = "http://localhost:8800/subject";
  TextEditingController nc = new TextEditingController();
  TextEditingController ic = new TextEditingController();
  TextEditingController chc = new TextEditingController();
  // TextEditingController nameco = new TextEditingController();
  bool isedit = false;
  int id = 0;
  String subjectId = '';
  String subjectName = '';
  int creditHour = 0;

  String? grade;
  final List<String> grades = List.generate(12, (i) => (i + 1).toString());
  Future<List<Subject>> fetchSubjects() async {
    final response = await http.get(Uri.parse(baseUrl));
    // print(response.body);
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) => Subject.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load subjects');
    }
  }

  // Future<void> updateSubject(Subject subject) async {
  //   final response = await http.put(
  //     Uri.parse('$baseUrl/${subject.id}'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode(subject.toJson()),
  //   );
  //   if (response.statusCode == 200) {
  //     print("Subject updated successfully");
  //   } else {
  //     throw Exception('Failed to update subject');
  //   }
  // }

  void deleteSubject(int id) {
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
                final response = await http.delete(Uri.parse('$baseUrl/$id'));
                print(response.statusCode);
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

  Future<void> saveSubject() async {
    int gread = int.parse(grade!);
    // print(creditHour);
    if (_formKey.currentState?.validate() == true) {
      Subject subject = Subject(
        id: id,
        name: nc.text,
        code: ic.text,
        ch: int.parse(chc.text) ?? 0,
        gread: gread,
      );
      print(subject.printer());
      final response =
          isedit
              ? await http.put(
                Uri.parse('$baseUrl/$id'),
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode(subject.toJson()),
              )
              : await http.post(
                Uri.parse(baseUrl),
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode(subject.toJson()),
              );
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
      } else {
        print(
          'Failed to insert data: ${response.statusCode} - ${response.body}',
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Subject Registered: $subjectName')),
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopBare(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {}),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  showAddSubjectDialog();
                },
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<Subject>>(
              future: fetchSubjects(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text("No subjects found.");
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final subject = snapshot.data![index];
                      return ListTile(
                        title: Text(subject.name),
                        subtitle: Text(
                          "Code: ${subject.code}, CH: ${subject.ch}, Grade: ${subject.gread}",
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: const Color.fromARGB(255, 35, 25, 234),
                              ),

                              onPressed: () {
                                setState(() {
                                  id = subject.id;
                                  isedit = true;
                                });
                                nc.text = subject.name;
                                grade = subject.gread.toString();
                                chc.text = subject.ch.toString();
                                ic.text = subject.code;
                                id = subject.id;
                                showAddSubjectDialog();
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteSubject(subject.id),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void showAddSubjectDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Subject Registeration Form"),
              TextButton(
                onPressed: () {
                  // Handle cancel action
                  Navigator.pop(context);
                },
                child: Icon(Icons.cancel, color: Colors.red),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10.0),

              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Subject ID'),
                      controller: ic,
                      onSaved: (value) => subjectId = value ?? '',
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Enter Subject ID'
                                  : null,
                    ),
                    TextFormField(
                      controller: nc,
                      decoration: InputDecoration(labelText: 'Subject Name'),
                      onSaved: (value) => subjectName = value ?? '',
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Enter Subject Name'
                                  : null,
                    ),
                    TextFormField(
                      controller: chc,
                      decoration: InputDecoration(labelText: 'Credit Hour'),
                      keyboardType: TextInputType.number,
                      onSaved:
                          (value) => creditHour = int.parse(value ?? '0') ?? 0,
                      validator: (value) {
                        final num = int.tryParse(value ?? '');
                        if (num == null || num <= 0)
                          return 'Enter valid credit hour';
                        return null;
                      },
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Grade'),
                      value: grade,
                      items:
                          grades.map((g) {
                            return DropdownMenuItem(
                              value: g,
                              child: Text("Grade : $g"),
                            );
                          }).toList(),
                      onChanged: (value) => setState(() => grade = value),
                      validator:
                          (value) => value == null ? 'Select grade' : null,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      child: Text('Register Subject'),
                      onPressed: saveSubject,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
