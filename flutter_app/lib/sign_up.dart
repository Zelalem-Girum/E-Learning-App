import 'package:flutter/material.dart';
import 'package:flutter_app/student_dashboard.dart';
import 'package:flutter_app/teacherPages/teacher_dashboard.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpPageState createState() => _SignUpPageState();
}

enum Role { student, teacher }

class _SignUpPageState extends State<SignUpPage> {
  Role? _selectedRole;
  final _formKey = GlobalKey<FormState>();

  // Common fields
  String _fullName = '';
  String _email = '';
  String _password = '';

  // Student fields
  int? _grade;
  String? _section;

  // Teacher fields
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Ethiopian Curriculum Sign Up'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Role selection
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
              // Common fields
              TextFormField(
                decoration: InputDecoration(labelText: 'Full Name'),
                validator:
                    (val) =>
                        val == null || val.isEmpty ? 'Enter full name' : null,
                onSaved: (val) => _fullName = val!,
              ),
              SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator:
                    (val) =>
                        val == null || !val.contains('@')
                            ? 'Enter valid email'
                            : null,
                onSaved: (val) => _email = val!,
              ),
              SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator:
                    (val) =>
                        val == null || val.length < 6
                            ? 'Minimum 6 characters'
                            : null,
                onSaved: (val) => _password = val!,
              ),
              SizedBox(height: 16),
              if (_selectedRole == Role.student) ...[
                // Student-specific fields
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(labelText: 'Grade'),
                  items: List.generate(
                    12,
                    (i) => DropdownMenuItem(
                      value: i + 1,
                      child: Text('Grade ${i + 1}'),
                    ),
                  ),
                  validator: (val) => val == null ? 'Select grade' : null,
                  onChanged: (val) => setState(() => _grade = val),
                  onSaved: (val) => _grade = val,
                ),
                SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Section'),
                  validator:
                      (val) =>
                          val == null || val.isEmpty
                              ? 'Enter section (e.g., A, B)'
                              : null,
                  onSaved: (val) => _section = val,
                ),
              ],
              if (_selectedRole == Role.teacher) ...[
                // Teacher-specific fields
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Subject'),
                  items:
                      _teacherSubjects
                          .map(
                            (subj) => DropdownMenuItem(
                              value: subj,
                              child: Text(subj),
                            ),
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
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() &&
                      _selectedRole != null) {
                    // Your authentication logic here

                    // Navigate based on role
                    if (_selectedRole == Role.student) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentDashboard(),
                        ),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeacherDashboard(),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please select your role')),
                    );
                  }
                },
                child: Text('Signup'),
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     if (_formKey.currentState?.validate() ?? false) {
              //       _formKey.currentState?.save();
              //       // Process the sign-up data here
              //       showDialog(
              //         context: context,
              //         builder:
              //             (_) => AlertDialog(
              //               title: Text('Signup Successful'),
              //               content: Text(
              //                 _selectedRole == Role.student
              //                     ? 'Welcome, $_fullName (Student, Grade $_grade Section $_section)'
              //                     : 'Welcome, $_fullName (Teacher of $_subject for Grades ${_teachingGrades.join(", ")})',
              //               ),
              //               actions: [
              //                 TextButton(
              //                   onPressed: () => Navigator.pop(context),
              //                   child: Text('OK'),
              //                 ),
              //               ],
              //             ),
              //       );
              //     }
              //   },
              //   child: Text('Sign Up'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
