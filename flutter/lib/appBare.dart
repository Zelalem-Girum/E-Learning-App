import 'package:flutter/material.dart';

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
              _headerButton(context, 'Sign up'),
              _headerButton(context, 'login'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerButton(BuildContext context, String title) {
    return InkWell(
      onTap: () {
        switch (title) {
          case 'Sign up':
            Navigator.pushNamed(context, '/signup');
            break;
          case 'login':
            Navigator.pushNamed(context, '/login');
            break;
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(title, style: TextStyle(color: Colors.white, fontSize: 14)),
      ),
    );
  }
}
