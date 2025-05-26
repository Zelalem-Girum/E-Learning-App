import 'package:flutter/material.dart';
import 'package:v1/loginpage.dart';
import 'package:v1/register.dart';

class AuthScreen extends StatefulWidget {
  bool isRegisterSelected, islogin;
  AuthScreen({
    required this.isRegisterSelected,
    required this.islogin,
    super.key,
  });
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // Theme color
        title: Text(
          "Ethiopian E-Learning Platform",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // Navigate to Login Screen
              Navigator.pushNamed(context, '/login');
            },
            child: Text(
              "Login",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Navigate to Sign Up Screen
              Navigator.pushNamed(context, '/signup');
            },
            child: Text(
              "Sign Up",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      body: Row(
        children: [
          // Left side with text
          Expanded(
            flex: 2,
            child: Container(
              color: const Color(0xFFE6F0FA), // Light blue background
              padding: const EdgeInsets.all(40.0),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Start learning\nwith the Digital\nEthiopia\nLearning\nPlatform',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A3C6D), // Dark blue text
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Right side with form
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF1A3C6D),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, "/");
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/");
                        },
                        child: const Text(
                          'Home Screen',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF1A3C6D),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),
                  // Register and Sign in tabs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.isRegisterSelected = true;
                          });
                        },
                        child: Column(
                          children: [
                            Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    widget.isRegisterSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                color:
                                    widget.isRegisterSelected
                                        ? const Color(0xFF1A3C6D)
                                        : Colors.grey[600],
                              ),
                            ),
                            if (widget.isRegisterSelected)
                              Container(
                                height: 2,
                                width: 50,
                                color: const Color(0xFF1A3C6D),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.isRegisterSelected = false;
                          });
                        },
                        child: Column(
                          children: [
                            Text(
                              'Sign in',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    !widget.isRegisterSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                color:
                                    !widget.isRegisterSelected
                                        ? const Color(0xFF1A3C6D)
                                        : Colors.grey[600],
                              ),
                            ),
                            if (!widget.isRegisterSelected)
                              Container(
                                height: 2,
                                width: 50,
                                color: const Color(0xFF1A3C6D),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // Conditionally display the form based on the selected tab
                  Expanded(
                    child: SingleChildScrollView(
                      child:
                          widget.isRegisterSelected
                              ? const RegisterForm()
                              : const SignInForm(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
