import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v1/studentActivity/appbar.dart';

class SubjectLearningPage extends StatefulWidget {
  SubjectLearningPage({Key? key}) : super(key: key);

  @override
  State<SubjectLearningPage> createState() => _SubjectLearningPageState();
}

class _SubjectLearningPageState extends State<SubjectLearningPage> {
  late int sid = 0;
  @override
  void initState() {
    super.initState();

    tast();
  }

  void tast() async {
    final prefs = await SharedPreferences.getInstance();
    print("Subject id: ${prefs.getInt("sid")}");
    setState(() {
      sid = prefs.getInt("sid")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopBare(),
            Image.asset(
              'assets/images/i1.jpg', // 👈 Add a nice image for learning
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to $sid',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Here you will find notes, videos, quizzes, and practice exercises to master $sid.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'What you will learn:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            lister(context, 'Key concepts and formulas', '/student/read'),
            lister(context, 'Interactive quizzes', '/student/quiz'),
            lister(context, 'Video tutorials', '/student/activity'),
            lister(
              context,
              'Practice questions and answers',
              '/student/activity',
            ),
          ],
        ),
      ),
    );
  }

  Widget lister(BuildContext context, String text, String link) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, link),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 20),
            SizedBox(width: 8),
            Expanded(child: Text(text, style: TextStyle(fontSize: 16))),
          ],
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 20),
            SizedBox(width: 8),
            Expanded(child: Text(text, style: TextStyle(fontSize: 16))),
          ],
        ),
      ),
    );
  }
}
