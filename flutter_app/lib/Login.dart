import 'package:flutter/material.dart';
import 'package:flutter_app/student_dashboard.dart';
import 'package:flutter_app/teacherPages/teacher_dashboard.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum Role { student, teacher }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Role? _selectedRole;
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _loading = false;

  Future<void> _loginWithGoogle() async {
    setState(() => _loading = true);
    try {
      final GoogleSignInAccount? account = await GoogleSignIn().signIn();
      if (account != null) {
        // TODO: Authenticate with your backend/Firebase using account info
        _showDialog('Google Sign-In successful', account.email);
      }
    } catch (e) {
      _showDialog('Google Sign-In failed', e.toString());
    }
    setState(() => _loading = false);
  }

  void _loginWithEmail() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      // TODO: Authenticate with backend/Firebase here
      _showDialog(
        'Login successful',
        'Role: ${_selectedRole == Role.student ? "Student" : "Teacher"}\nEmail: $_email',
      );
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('E-learning Platform Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Role selection
                ListTile(
                  leading: Radio<Role>(
                    value: Role.student,
                    groupValue: _selectedRole,
                    onChanged: (r) => setState(() => _selectedRole = r),
                  ),
                  title: Text('Student'),
                ),
                ListTile(
                  leading: Radio<Role>(
                    value: Role.teacher,
                    groupValue: _selectedRole,
                    onChanged: (r) => setState(() => _selectedRole = r),
                  ),
                  title: Text('Teacher'),
                ),
                SizedBox(height: 16),

                // Email
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator:
                      (val) =>
                          val == null || !val.contains('@')
                              ? 'Enter valid email'
                              : null,
                  onSaved: (val) => _email = val!.trim(),
                ),
                SizedBox(height: 8),

                // Password
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

                  child: Text('Login'),
                ),
                SizedBox(height: 16),

                // Google Sign-In
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: Image.asset(
                      'assets/images/google_logo.png',
                      height: 15,
                      width: 15,
                    ),
                    label: Text('Login with Google'),
                    onPressed: _loading ? null : _loginWithGoogle,
                  ),
                ),
                if (_loading) ...[
                  SizedBox(height: 24),
                  CircularProgressIndicator(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
