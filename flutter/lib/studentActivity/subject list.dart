// ignore: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:v1/models/subject.dart';
import 'package:v1/studentActivity/appbar.dart';

class SubjectsList extends StatefulWidget {
  const SubjectsList({super.key});

  @override
  State<SubjectsList> createState() => _SubjectsListState();
}

class _SubjectsListState extends State<SubjectsList> {
  List<Subject> subjects = [];
  List<Subject> allsubjects = [];
  final Map<int, List<String>> subjectsByGrade = {
    1: [],
    2: [],
    3: [],
    4: [],
    5: [],
    6: [],
    7: [],
    8: [],
    9: [],
    10: [],
    11: [],
    12: [],
  };
  final Map<int, String> img = {
    1: "assets/images/es.jpg",
    2: "assets/images/es.jpg",
    3: "assets/images/es.jpg",
    4: "assets/images/es.jpg",
    5: "assets/images/es.jpg",
    6: "assets/images/es.jpg",
    7: "assets/images/es.jpg",
    8: "assets/images/es.jpg",
    9: "assets/images/es.jpg",
    10: "assets/images/es.jpg",
    11: "assets/images/es.jpg",
    12: "assets/images/es.jpg",
  };
  bool isLoading = true;
  String? errorMessage;

  var baseUrl = "http://localhost:8800/subject";

  @override
  void initState() {
    super.initState();
    fetchSubjects();
  }

  int? getSubjectId(List<Subject> subjects, String name, int grade) {
    try {
      return subjects
          .firstWhere(
            (s) =>
                s.name.toLowerCase() == name.toLowerCase() && s.gread == grade,
          )
          .id;
    } catch (e) {
      return null;
    }
  }

  Future<void> fetchSubjects() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    final prefs = await SharedPreferences.getInstance();
    print("Username: ${prefs.getString("username")}");
    print("Password: ${prefs.getString("password")}");
    print("IsLogin: ${prefs.getString("islogin")}");

    for (int i = 1; i <= 12; i++) {
      try {
        final response = await http.get(Uri.parse("$baseUrl/$i"));
        if (response.statusCode == 200) {
          List jsonList = jsonDecode(response.body);
          subjects.addAll(
            jsonList.map((json) => Subject.fromJson(json)).toList(),
          );
          allsubjects.addAll(subjects);
          for (Subject s in subjects) {
            subjectsByGrade[s.gread]?.add(s.name);
          }
          subjects.clear();
        } else {
          throw Exception('Failed to load subjects: ${response.statusCode}');
        }
      } catch (e) {
        setState(() {
          errorMessage = 'Error fetching data: $e';
          isLoading = false;
        });
        return;
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          isLoading
              ? Center(child: CircularProgressIndicator(color: Colors.teal))
              : errorMessage != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: fetchSubjects,
                      child: Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                    ),
                  ],
                ),
              )
              : RefreshIndicator(
                onRefresh: fetchSubjects,
                child: Column(
                  children: [
                    TopBare(),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: subjectsByGrade.keys.length,
                        itemBuilder: (context, index) {
                          int grade = subjectsByGrade.keys.elementAt(index);
                          String message =
                              grade <= 4
                                  ? "Grade $grade (Lower Primary)"
                                  : grade <= 8
                                  ? "Grade $grade (Upper Primary)"
                                  : grade < 10
                                  ? "Grade $grade (General Secondary)"
                                  : "Grade $grade (Preparatory)";
                          List<String> subjects = subjectsByGrade[grade]!;

                          return Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ExpansionTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.teal.withOpacity(0.1),
                                  child: Text(
                                    '$grade',
                                    style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        img[grade]!,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        message,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          color: Colors.teal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                collapsedBackgroundColor: Colors.white,
                                backgroundColor: Colors.teal.withOpacity(0.05),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                children:
                                    subjects
                                        .asMap()
                                        .entries
                                        .map(
                                          (entry) => ListTile(
                                            onTap: () async {
                                              int? id = getSubjectId(
                                                allsubjects,
                                                entry.value,
                                                grade,
                                              );
                                              print("Subject :$entry");
                                              final prefs =
                                                  await SharedPreferences.getInstance();
                                              await prefs.setInt("sid", id!);
                                              if (id != null) {
                                                Navigator.pushNamed(
                                                  context,
                                                  '/student/lerning',
                                                );
                                              }
                                            },
                                            leading: Icon(
                                              Icons.book,
                                              color: Colors.teal,
                                            ),
                                            title: Text(
                                              entry.value,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            trailing: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 16,
                                              color: Colors.teal,
                                            ),
                                            tileColor:
                                                entry.key % 2 == 0
                                                    ? Colors.white
                                                    : Colors.teal.withOpacity(
                                                      0.02,
                                                    ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 8,
                                                ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        )
                                        .toList(),
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
