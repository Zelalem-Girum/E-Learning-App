import 'package:flutter/material.dart';
import 'package:v1/TecherActivety/chating%20home%20.dart';
import 'package:v1/TecherActivety/chating.dart';
import 'package:v1/TecherActivety/home.dart';
import 'package:v1/TecherActivety/quiz/SchoolAssignmentApp%20.dart';
import 'package:v1/TecherActivety/quiz/quiz.dart';
import 'package:v1/appBare.dart';
import 'package:v1/studentActivity/Reading%20Text%20File.dart';
import 'package:v1/studentActivity/chating%20home%20.dart';
import 'package:v1/TecherActivety/quiz/subject%20page.dart';
import 'package:v1/studentActivity/chating.dart';
import 'package:v1/studentActivity/quezpage.dart';
import 'package:v1/studentActivity/some%20excercice.dart';
import 'package:v1/studentActivity/subject list.dart';
import 'package:v1/seporttwo.dart';
import 'package:v1/studentActivity/subject%20plylist.dart';
import 'package:v1/studentActivity/videotetorial.dart';
import 'package:v1/login to chating page.dart';

import 'TecherActivety/quiz/prepare Note.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
      routes: {
        '/student/read':
            (context) => Scaffold(body: Center(child: ReadingTextFile())),
        '/chat': (context) => Scaffold(body: Center(child: ChatScreen())),
        '/techer/titory_note':
            (context) => Scaffold(body: Center(child: TitorialListScreen())),
        '/techer/assigment':
            (context) => Scaffold(body: Center(child: CreateAssignmentPage())),
        '/subject':
            (context) =>
                Scaffold(body: Center(child: SubjectRegistrationPage())),
        '/techor/chathom':
            (context) => Scaffold(body: Center(child: TecherGoodPhonesList())),
        '/techer/chatting':
            (context) => Scaffold(body: Center(child: TecherChatingScrean())),
        '/testp': (context) => Scaffold(body: Center(child: GoodPhonesList())),
        '/subjects':
            (context) => Scaffold(body: Center(child: GoodPhonesList())),
        '/student/test':
            (context) =>
                Scaffold(body: Center(child: InteractiveQuizzesPage())),
        '/student/activity':
            (context) => Scaffold(body: Center(child: PracticeApp())),
        '/thome':
            (context) => Scaffold(body: Center(child: TeacherHomeScreen())),
        '/student/lerning':
            (context) => Scaffold(body: Center(child: SubjectLearningPage())),
        // '/thome/quize':
        //     (context) => Scaffold(body: Center(child: HomeScreen())),
        '/student/videotetorial':
            (context) => Scaffold(body: Center(child: VideoPlayerScreen())),
        '/thome/quize':
            (context) => Scaffold(body: Center(child: QuizListPage())),
        '/student/chathom':
            (context) => Scaffold(body: Center(child: GoodPhonesList())),
        '/student/chatting':
            (context) => Scaffold(body: Center(child: ChatScreen1())),
        '/thome/assigment':
            (context) => Scaffold(body: Center(child: CreateAssignmentPage())),
        '/student/home':
            (context) => Scaffold(body: Center(child: SubjectsList())),
        '/student/quiz':
            (context) =>
                Scaffold(body: Center(child: InteractiveQuizzesPage())),
        '/login':
            (context) => Scaffold(
              body: Center(
                child: AuthScreen(isRegisterSelected: false, islogin: false),
              ),
            ),
        '/signup':
            (context) => Scaffold(
              body: Center(
                child: AuthScreen(isRegisterSelected: true, islogin: false),
              ),
            ),
      },
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopBare(),
            // Hero Section
            Container(
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  // Description Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome to the Ethiopian E-Learning Platform",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Our platform is designed to align with the Ethiopian education curriculum, "
                          "providing students and educators with access to high-quality resources, "
                          "interactive learning tools, and personalized support. "
                          "Empower your learning journey with us!",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to Signup Screen
                            Navigator.pushNamed(context, '/signup');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Get Started",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  // Placeholder for Image/Graphic
                  Expanded(
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/education.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Ethiopian Curriculum Section
            Text(
              "About the Ethiopian Education Curriculum",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            SizedBox(height: 10),
            Text(
              "The Ethiopian education system emphasizes quality learning "
              "and inclusivity, catering to diverse needs of students across the country. "
              "Our platform integrates with the national curriculum, providing grade-specific content "
              "in subjects such as Mathematics, Science, Social Studies, and more. "
              "We aim to bridge the gap in education through engaging and interactive tools.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
                height: 1.5,
              ),
            ),
            SizedBox(height: 20),

            // Key Features Section
            Text(
              "Why Choose Our Platform?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFeatureItem(
                  icon: Icons.school,
                  title: "Curriculum-Aligned Content",
                  description:
                      "Our platform is tailored to the Ethiopian education curriculum, ensuring students learn exactly what they need.",
                ),
                _buildFeatureItem(
                  icon: Icons.interests,
                  title: "Interactive Learning",
                  description:
                      "Engage with interactive tools, videos, and quizzes to make learning fun and effective.",
                ),
                _buildFeatureItem(
                  icon: Icons.support,
                  title: "Teacher Support",
                  description:
                      "Teachers can access tools to track progress, manage resources, and support students effectively.",
                ),
                _buildFeatureItem(
                  icon: Icons.language,
                  title: "Multilingual Support",
                  description:
                      "Content is available in multiple Ethiopian languages to enhance accessibility and inclusivity.",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget for a single feature item
  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: Colors.green),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
