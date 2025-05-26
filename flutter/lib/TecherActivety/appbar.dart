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
              _headerButton(context, 'Home', '/thome'),
              _headerButton(context, 'About', '/thome'),
              _headerButton(context, 'Resources', '/thome'),
              _headerButton(context, 'Contact', '/thome'),
              _headerButton(context, 'Chatting', '/techor/chathom'),
              _headerButton(context, 'Log Out', '/'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerButton(BuildContext context, String title, String link) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, link);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(title, style: TextStyle(color: Colors.white, fontSize: 14)),
      ),
    );
  }
}
