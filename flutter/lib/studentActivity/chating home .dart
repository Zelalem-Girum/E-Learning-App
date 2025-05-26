import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v1/models/StudentModels.dart';
import 'package:v1/models/user.dart';
import 'package:v1/studentActivity/appbar.dart';

List<User> getGoodPhoneUsers(List<User> users) {
  return users.where((u) {
    return u.phone.length >= 10 && u.phone.startsWith('09');
  }).toList();
}

class GoodPhonesList extends StatefulWidget {
  @override
  State<GoodPhonesList> createState() => _GoodPhonesListState();
}

class _GoodPhonesListState extends State<GoodPhonesList> {
  List<StudentModels> contacts = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://localhost:8800/stu'));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      List<StudentModels> list =
          (data).map((json) => StudentModels.fromJson(json)).toList();
      setState(() {
        contacts.addAll(list);
      });
    } else {
      throw Exception('Failed to load data');
    }
    print(contacts.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopBare(),
          Expanded(
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final user = contacts[index];
                return ListTile(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString("emailin", user.email);
                    Navigator.pushNamed(context, '/student/chatting');
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Text(
                      user.fname[0].toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(user.fname),
                  subtitle: Text(user.email),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
