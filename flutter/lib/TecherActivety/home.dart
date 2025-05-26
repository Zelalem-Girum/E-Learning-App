import 'package:flutter/material.dart';
import 'package:v1/TecherActivety/appbar.dart';
import 'package:v1/slect%20subject.dart';

class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 122, 222, 233),
      body: Column(
        children: [
          TopBare(),
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              children: [
                _buildCard(
                  context,
                  title: 'My Subjects',
                  icon: Icons.book,
                  color: Colors.orange,
                  link: '/subject',
                ),
                _buildCard(
                  context,
                  title: 'Create Quizzes',
                  icon: Icons.quiz,
                  color: Colors.blue,
                  link: '/thome/quize',
                ),
                _buildCard(
                  context,
                  title: 'Create Assigment',
                  icon: Icons.book,
                  color: const Color.fromARGB(255, 71, 250, 151),
                  link: '/techer/assigment',
                ),

                _buildCard(
                  context,
                  title: 'Prepare Subject Note',
                  icon: Icons.book,
                  color: const Color.fromARGB(255, 71, 250, 151),
                  link: '/techer/titory_note',
                ),
                _buildCard(
                  context,
                  title: 'Student Chat',
                  icon: Icons.chat,
                  color: Colors.green,
                  link: '/techor/chathom',
                ),
                _buildCard(
                  context,
                  title: 'Announcements',
                  icon: Icons.announcement,
                  color: Colors.deepPurple,
                  link: "",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String link,
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        title == "My Subjects"
            ? Navigator.pushNamed(context, link)
            : showAddSubjectDialog(context, link);
      },
      child: Card(
        color: color.withOpacity(0.85),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        // elevation: 5,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showAddSubjectDialog(BuildContext context, String link) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Subject Registeration Form"),
              TextButton(
                onPressed: () {
                  // Handle cancel action
                  Navigator.pop(context);
                },
                child: Icon(Icons.cancel, color: Colors.red),
              ),
            ],
          ),
          content: SingleChildScrollView(child: SelectSebjects(link: link)),
        );
      },
    );
  }
}
