import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum Role { student, teacher }

// Register Form Widget
class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  var baseUrl = "http://localhost:8800/stu";
  final _formKey = GlobalKey<FormState>();
  final _fname = TextEditingController();
  final _lname = TextEditingController();
  final _mname = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  Role? _selectedRole;

  int? _grade;
  final List<String> _teacherSubjects = [
    "Mathematics",
    "English",
    "Amharic",
    "Physics",
    "Biology",
    "Chemistry",
    "History",
    "Geography",
    "Civics",
    "ICT",
  ];
  String? _subject;
  final List<int> _teachingGrades = [];

  @override
  void dispose() {
    _fname.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  var attrbut = "fname";

  void getSpacificStudent(String name) async {
    name = "$attrbut,$name";
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$name'), // Using URL parameter
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Parse and return the JSON response
        print(response.body);
      } else {
        print('Failed: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Creating Account...')));
      try {
        final response = await http.post(
          Uri.parse(baseUrl),
          headers: {
            'Content-Type':
                'application/json', // Adjust based on your API requirements
          },
          body: jsonEncode({
            "fname": _fname.text,
            "mname": _mname.text,
            "lname": _lname.text,
            "email": _emailController.text,
            "pass": _passwordController.text,
            "username": _usernameController.text,
            "rule":
                _selectedRole == Role.student
                    ? "Student"
                    : "Teacher", // fixed typo and comparison
            "balance": 400,
          }),
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          print('Data inserted successfully: ${response.body}');
        } else {
          print(
            'Failed to insert data: ${response.statusCode} - ${response.body}',
          );
        }
      } catch (e) {
        print('Error occurred: $e');
      }
      //var result=
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: const Text('Student'),
            leading: Radio<Role>(
              value: Role.student,
              groupValue: _selectedRole,
              onChanged: (Role? value) {
                setState(() {
                  _selectedRole = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Teacher'),
            leading: Radio<Role>(
              value: Role.teacher,
              groupValue: _selectedRole,
              onChanged: (Role? value) {
                setState(() {
                  _selectedRole = value;
                });
              },
            ),
          ),
          SizedBox(height: 16),
          // Ferst Name Field
          TextFormField(
            controller: _fname,
            decoration: InputDecoration(
              labelText: 'Ferst Name',
              labelStyle: TextStyle(color: Colors.grey[600]),
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF1A3C6D)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Ferst Name';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Midel Name Field
          TextFormField(
            controller: _mname,
            decoration: InputDecoration(
              labelText: 'Midle Name',
              labelStyle: TextStyle(color: Colors.grey[600]),
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF1A3C6D)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Midel Name';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Last Name Field
          TextFormField(
            controller: _lname,
            decoration: InputDecoration(
              labelText: 'Last Name',
              labelStyle: TextStyle(color: Colors.grey[600]),
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF1A3C6D)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Last Name';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Email Field
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: Colors.grey[600]),
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF1A3C6D)),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an email';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Username Field
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Public username',
              labelStyle: TextStyle(color: Colors.grey[600]),
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF1A3C6D)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a username';
              }
              if (value.length < 2 || value.length > 30) {
                return 'Username must be between 2 and 30 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Password Field
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(color: Colors.grey[600]),
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF1A3C6D)),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey[600],
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),

          if (_selectedRole == Role.teacher) ...[
            // Teacher-specific fields
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Subject'),
              items:
                  _teacherSubjects
                      .map(
                        (subj) =>
                            DropdownMenuItem(value: subj, child: Text(subj)),
                      )
                      .toList(),
              validator: (val) => val == null ? 'Select subject' : null,
              onChanged: (val) => setState(() => _subject = val),
              onSaved: (val) => _subject = val,
            ),
            SizedBox(height: 8),
            // Multiple grade selection
            FormField<List<int>>(
              initialValue: _teachingGrades,
              validator:
                  (grades) =>
                      grades == null || grades.isEmpty
                          ? 'Select teaching grades'
                          : null,
              builder: (state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Grades You Teach'),
                    Wrap(
                      spacing: 8,
                      children: List.generate(
                        12,
                        (i) => FilterChip(
                          label: Text('${i + 1}'),
                          selected: _teachingGrades.contains(i + 1),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _teachingGrades.add(i + 1);
                              } else {
                                _teachingGrades.remove(i + 1);
                              }
                            });
                            state.didChange(_teachingGrades);
                          },
                        ),
                      ),
                    ),
                    if (state.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          state.errorText ?? "",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
          SizedBox(height: 24),

          // Submit Button
          ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A3C6D),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Create an account for free',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
