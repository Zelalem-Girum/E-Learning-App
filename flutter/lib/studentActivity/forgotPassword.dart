import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:v1/seporttwo.dart'; // For launching email links

void main() {
  runApp(const ResetPasswordApp());
}

class ResetPasswordApp extends StatelessWidget {
  const ResetPasswordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ethiopia Learning Platform',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Roboto'),
      home: const ResetPasswordScreen(),
    );
  }
}

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sending reset instructions...')),
      );
      // Here you would typically send the email to your backend for password reset
      print('Email: ${_emailController.text}');
    }
  }

  void _navigateToSignIn() {
    // Placeholder for navigation to the Sign In screen
    print('Navigating to Sign In screen...');
  }

  // Function to launch email client
  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Password Reset Support',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch email client')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left side with text (minimized width)
          Expanded(
            flex: 2,
            child: Container(
              color: const Color(0xFFE6F0FA), // Light blue background
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: const SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start learning\nwith the Digital\nEthiopia\nLearning\nPlatform',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A3C6D), // Dark blue text
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Right side with form (maximized width)
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    // Back to Sign in link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Color(0xFF1A3C6D),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => AuthScreen(
                                      isRegisterSelected: false,
                                      islogin: false,
                                    ),
                              ),
                            );
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => AuthScreen(
                                      isRegisterSelected: false,
                                      islogin: false,
                                    ),
                              ),
                            );
                          },
                          child: const Text(
                            'Sign in',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF1A3C6D),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    // Reset Password Form
                    const Text(
                      'Reset password',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A3C6D),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Please enter your email address below and we will send you an email with instructions on how to reset your password.',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email Field
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.grey[600]),
                              border: const OutlineInputBorder(),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF1A3C6D),
                                ),
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
                          const SizedBox(height: 30),
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
                              'Submit',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Support Email Link
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text:
                              'For additional help, contact Digital Ethiopia Learning Platform support at ',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                          children: [
                            WidgetSpan(
                              child: GestureDetector(
                                onTap:
                                    () => _launchEmail(
                                      'mintlearningcenter2024@gmail.com',
                                    ),
                                child: const Text(
                                  'mintlearningcenter2024@gmail.com',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
