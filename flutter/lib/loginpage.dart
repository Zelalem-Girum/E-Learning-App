import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:v1/studentActivity/forgotPassword.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _usernameOrEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // API URL
  final String url = "http://localhost:8800/stu"; // Adjusted for POST request

  // Password validation RegExp
  final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  @override
  void dispose() {
    _usernameOrEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> readStudent() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a role and fill all fields correctly'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    String name = _usernameOrEmailController.text;
    String pass = _passwordController.text;
    try {
      var reasult = await http.get(Uri.parse("$url/$pass/$name"));
      List data = jsonDecode(reasult.body);
      if (data.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Incorect Password or UserName'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        if (reasult.statusCode == 200) {
          setState(() {
            isLoading = false;
          });
          // print(data[0][""]);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("username", name);
          await prefs.setString("password", pass);
          await prefs.setString("emailout", data[0]["email"]);

          if (data[0]["rule"] == "Student") {
            Navigator.pushNamed(context, '/student/home');
          } else {
            Navigator.pushNamed(context, '/thome');
          }
        }
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login Successfully: ${reasult.reasonPhrase}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          // Username or Email Field
          TextFormField(
            controller: _usernameOrEmailController,
            decoration: InputDecoration(
              labelText: 'Username or email',
              labelStyle: TextStyle(color: Colors.grey[600]),
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF1A3C6D)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username or email';
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
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          // Sign in Button and Forgot Password Link
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: isLoading ? null : readStudent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A3C6D),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          'Sign in',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResetPasswordScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Forgot password',
                  style: TextStyle(fontSize: 14, color: Color(0xFF1A3C6D)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
