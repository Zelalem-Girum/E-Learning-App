import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:v1/TecherActivety/appbar.dart';
import 'package:v1/models/subject.dart';
import 'package:v1/models/titory.dart';

class TitorialListScreen extends StatefulWidget {
  const TitorialListScreen({super.key});

  @override
  _TitorialListScreenState createState() => _TitorialListScreenState();
}

class _TitorialListScreenState extends State<TitorialListScreen> {
  // Sample list of Titorial objects
  List<Titorial> titorials = [];
  final List<String> chapters = [];
  List<Titorial> alltitrole = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  bool islod = true;
  bool isadd = false;
  int? tid;
  bool isread = false;
  String url = "http://localhost:8800/titory";
  Future<void> fetchData() async {
    final response1 = await http.get(Uri.parse(url));
    if (response1.statusCode == 200) {
      // If the server returns a 200 OK response
      setState(() {
        List data = jsonDecode(response1.body); // Parse the JSON response
        // print(data);
        alltitrole.clear();
        alltitrole.addAll(data.map((d) => Titorial.fromJson(d)));
        setState(() {
          islod = false;
        });
        // print(alltitrole.length);
        isread = true;
      });
    } else {}
    final response = await http.get(Uri.parse("$url/$tid"));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response
      setState(() {
        List data = jsonDecode(response.body); // Parse the JSON response
        // print(data);
        titorials.clear();
        titorials.addAll(data.map((d) => Titorial.fromJson(d)));
        isread = true;
      });
    } else {
      // If the server returns an error
      setState(() {
        // isLoading = false;  // Stop loading
      });
      throw Exception('Failed to load data');
    }
    print(titorials.length);
  }

  void _editTitorial(Titorial titorial) {
    // Placeholder for edit action
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Editing ${titorial.title}')));
    // TODO: Navigate to an edit screen with titorial data
  }

  void _deleteTitorial(Titorial titorial) {
    setState(() {
      titorials.remove(titorial);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${titorial.title} deleted')));
  }

  @override
  Widget build(BuildContext context) {
    return islod
        ? CircularProgressIndicator()
        : isadd
        ? SubjectMaterialPrepare()
        : Scaffold(
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical, // Enable horizontal scrolling
            child: Column(
              children: [
                TopBare(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        setState(() {
                          // isback = true;
                        });
                      },
                      color: const Color.fromARGB(255, 102, 83, 248),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          isadd = true;
                        });
                      },
                      color: const Color.fromARGB(255, 102, 83, 248),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        Navigator.pushNamed(context, '/techer/titory_note');
                      },
                      color: const Color.fromARGB(255, 102, 83, 248),
                    ),
                  ],
                ),

                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth:
                        MediaQuery.of(context).size.width, // Full screen width
                  ),
                  child: DataTable(
                    columnSpacing: 20, // Adjust spacing between columns
                    columns: const [
                      DataColumn(
                        label: Text(
                          'ID',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Title',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'SID',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Chapter',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Part',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Actions',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows:
                        alltitrole.map((titorial) {
                          return DataRow(
                            cells: [
                              DataCell(Text(titorial.id.toString())),
                              DataCell(Text(titorial.title)),
                              DataCell(Text(titorial.sid.toString())),
                              DataCell(Text(titorial.chapter.toString())),
                              DataCell(Text(titorial.part.toString())),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () => _editTitorial(titorial),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed:
                                          () => _deleteTitorial(titorial),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
  }
}

// Global Subject List
List<Subject> subjects = [];

// Subject Registration Page
class SubjectMaterialPrepare extends StatefulWidget {
  @override
  _SubjectMaterialPrepareState createState() => _SubjectMaterialPrepareState();
}

class _SubjectMaterialPrepareState extends State<SubjectMaterialPrepare> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titlec = TextEditingController();
  TextEditingController notec = TextEditingController();
  int? selectedGrade;
  int? selectedSubject;
  int? part;
  int? chapter;
  List<Subject> subjects = [];
  bool selectGread = false;
  @override
  void dispose() {
    titlec.dispose();
    notec.dispose();
    super.dispose();
  }

  // Future<List<Subject>> fetchSubjects() async {
  //   final response = await http.get(Uri.parse(baseUrl));
  //   if (response.statusCode == 200) {
  //     List data = jsonDecode(response.body);
  //     return data.map((json) => Subject.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load subjects');
  //   }
  // }

  int? id;
  bool isedit = false;
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
    // print(creditHour);
    String url = "http://localhost:8800/titory";
    if (_formKey.currentState?.validate() == true) {
      Titorial titory = new Titorial(
        title: titlec.text,
        note: notec.text,
        sid: selectedSubject!,
        chapter: chapter!,
        part: part!,
      );
      print(titory.printer());
      final response =
          isedit
              ? await http.put(
                Uri.parse('$url/$id'),
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode(titory.toJson()),
              )
              : await http.post(
                Uri.parse(url),
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode(titory.toJson()),
              );
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
      } else {
        print(
          'Failed to insert data: ${response.statusCode} - ${response.body}',
        );
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Tetorial  Registered')));
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  var baseUrl = "http://localhost:8800/subject";
  Future<void> fetchSubject(i) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/$i"));
      if (response.statusCode == 200) {
        List jsonList = jsonDecode(response.body);
        print(response.body);
        // print(response.body);
        setState(() {
          subjects.addAll(
            jsonList.map((json) => Subject.fromJson(json)).toList(),
          );
          selectGread = true;
        });
      } else {
        throw Exception('Failed to load subjects: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
    print(subjects.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subject Registration'),
        backgroundColor: const Color.fromARGB(255, 13, 246, 102),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: titlec,
                decoration: InputDecoration(labelText: 'Enter Title Of Note'),
                validator:
                    (value) => value!.isEmpty ? 'Enter Title Of Note' : null,
              ),
              DropdownButtonFormField<int>(
                value: selectedGrade,
                decoration: InputDecoration(labelText: 'Select Grade'),
                items: List.generate(12, (index) {
                  return DropdownMenuItem<int>(
                    value: index + 1,
                    child: Text('Grade ${index + 1}'),
                  );
                }),
                onChanged: (value) {
                  setState(() {
                    selectedGrade = value;
                  });
                  fetchSubject(value);
                },
                validator:
                    (value) => value == null ? 'Please select a grade' : null,
              ),

              SizedBox(height: 16),
              DropdownButton<int>(
                hint: Text("Select Your Want Subject"),
                value: selectedSubject,
                onChanged: (int? newValue) {
                  setState(() {
                    selectedSubject = newValue!;
                  });
                  print(newValue);
                },
                items:
                    subjects.map<DropdownMenuItem<int>>((Subject s) {
                      return DropdownMenuItem<int>(
                        value: s.id,
                        child: Text(s.name),
                      );
                    }).toList(),
              ),
              SizedBox(height: 16),
              TextFormField(
                // minLines: 2,
                maxLines: null, // Expands as you type
                minLines: 5,
                controller: notec,
                decoration: InputDecoration(labelText: 'Subject Code'),
                validator:
                    (value) => value!.isEmpty ? 'Enter subject code' : null,
              ),

              DropdownButtonFormField<int>(
                value: chapter,
                decoration: InputDecoration(labelText: 'Select Chapter'),
                items: List.generate(20, (index) {
                  return DropdownMenuItem<int>(
                    value: index + 1,
                    child: Text('Chapter ${index + 1}'),
                  );
                }),
                onChanged: (value) {
                  setState(() {
                    chapter = value;
                  });
                },
                validator:
                    (value) => value == null ? 'Please select a Chapter' : null,
              ),
              DropdownButtonFormField<int>(
                value: part,
                decoration: InputDecoration(labelText: 'Select Part'),
                items: List.generate(10, (index) {
                  return DropdownMenuItem<int>(
                    value: index + 1,
                    child: Text('Part ${index + 1}'),
                  );
                }),
                onChanged: (value) {
                  setState(() {
                    part = value;
                  });
                },
                validator:
                    (value) => value == null ? 'Please select a grade' : null,
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveSubject,
                child: Text('Register Subject'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
