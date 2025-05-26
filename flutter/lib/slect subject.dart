import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v1/models/subject.dart';

class SelectSebjects extends StatefulWidget {
  String link;
  SelectSebjects({super.key, required this.link});

  @override
  State<SelectSebjects> createState() => _SelectSebjectsState();
}

class _SelectSebjectsState extends State<SelectSebjects> {
  int? selectedGrade;

  int? selectedSubject;

  List<Subject> subjects = [];

  final _formKey = GlobalKey<FormState>();
  var baseUrl = "http://localhost:8800/subject";
  Future<void> fetchSubjects(int i) async {
    final response = await http.get(Uri.parse("$baseUrl/$i"));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      setState(() {
        subjects.addAll(data.map((json) => Subject.fromJson(json)).toList());
      });
    } else {
      throw Exception('Failed to load subjects');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<int>(
            value: selectedGrade,
            decoration: InputDecoration(
              labelText: 'Select Grade',
              prefixIcon: const Icon(Icons.school),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
            ),
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
              fetchSubjects(value!);
            },
            validator:
                (value) => value == null ? 'Please select a grade' : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            value: selectedSubject,
            decoration: InputDecoration(
              labelText: 'Select Subject',
              prefixIcon: const Icon(Icons.book),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
            ),
            items:
                subjects.map<DropdownMenuItem<int>>((Subject s) {
                  return DropdownMenuItem<int>(
                    value: s.id,
                    child: Text(s.name),
                  );
                }).toList(),
            onChanged: (value) {
              setState(() {
                selectedSubject = value;
              });
            },
            validator:
                (value) => value == null ? 'Please select a subject' : null,
            hint: const Text('Select Your Subject'),
          ),
          IconButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setInt("sid", selectedSubject!);

              Navigator.pushNamed(context, widget.link);
            },
            icon: Icon(Icons.arrow_forward_ios_outlined, color: Colors.green),
          ),
        ],
      ),
    );
  }
}
