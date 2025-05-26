import 'package:flutter/material.dart';
import 'package:v1/slect%20subject.dart';

class TopBare extends StatelessWidget {
  final Color primaryColor = Color(0xFF1B5E20);
  TopBare({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.school, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Digital Learning Ethiopia',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _headerButton(context, 'Home', '/student/home'),
              _headerButton(context, 'Chatting', '/student/chathom'),
              _headerButton(context, 'test', '/student/test'),
              _headerButton(context, 'Quize', '/student/test'),
              _headerButton(context, 'Video', '/student/videotetorial'),
              _headerButton(context, 'logout', '/'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerButton(BuildContext context, String title, String link) {
    return InkWell(
      onTap: () {
        title == "Home" || title == "logout" || title == "Chatting"
            ? Navigator.pushNamed(context, link)
            : showAddSubjectDialog(context, link);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(title, style: TextStyle(color: Colors.white, fontSize: 14)),
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
