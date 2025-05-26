import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v1/models/titory.dart';
import 'package:v1/studentActivity/appBar.dart';

class ReadingTextFile extends StatefulWidget {
  @override
  State<ReadingTextFile> createState() => _ReadingTextFileState();
}

class _ReadingTextFileState extends State<ReadingTextFile> {
  final List<String> chapters = [];
  List<Titorial> alltitrole = [];
  @override
  void initState() {
    super.initState();
    tast();
  }

  late int sid;
  void tast() async {
    final prefs = await SharedPreferences.getInstance();
    // print("Subject id1: ${prefs.getInt("sid")}");
    setState(() {
      sid = prefs.getInt("sid")!;
    });
    fetchData();
  }

  int? tid;
  List<Titorial> titoryals = [];
  bool isread = false;
  String url = "http://localhost:8800/titory";
  late Titorial titoris;
  Future<void> fetchData() async {
    // print('$url/$sid');
    final response1 = await http.get(Uri.parse("$url/$sid"));
    // print(response1.body);
    if (response1.statusCode == 200) {
      // If the server returns a 200 OK response
      setState(() {
        List data = jsonDecode(response1.body); // Parse the JSON response
        // print(data);
        alltitrole.clear();
        titoryals.addAll(data.map((d) => Titorial.fromJson(d)));
        // print(alltitrole.length);
        isread = true;
      });
    } else {}
    print(titoryals.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body:
          isread && titoryals.length > 0
              ? ReadingPage()
              : Column(
                children: [
                  TopBare(),
                  Expanded(
                    child: ListView(
                      children: [
                        // Course header card
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.deepPurple[50],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome to Grade 1 Mathematics!',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Master the basics of math with interactive lessons, videos, and quizzes.',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 20),
                              LinearProgressIndicator(
                                value: 0.3,
                                backgroundColor: Colors.grey[300],
                                color: Colors.deepPurple,
                              ),
                              SizedBox(height: 10),
                              Text('Progress: 30%'),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),

                        // Chapters list
                        Text(
                          'Chapters',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ...titoryals.map(
                          (t) => Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: Icon(
                                Icons.book,
                                color: Colors.deepPurple,
                              ),
                              title: Text(
                                "Chapter ${t.chapter} & Part ${t.part}: ${t.title}",
                              ),
                              trailing: Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                setState(() {
                                  isread = true;
                                });
                              },
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Video section
                        Text(
                          'Watch a Sample Lesson',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(
                                'https://img.youtube.com/vi/jfKfPfyJRdk/maxresdefault.jpg',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.play_circle_fill,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Quiz button
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.quiz),
                          label: Text('Start Quiz'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            textStyle: TextStyle(fontSize: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }

  Widget ReadingPage() {
    return ListView.builder(
      itemCount: titoryals.length,
      itemBuilder: (context, index) {
        Titorial t = titoryals[index];
        return getNotPage(t);
      },
    );
  }

  Widget getNotPage(Titorial? t) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                isread = false;
              });
            },
            child: Icon(Icons.back_hand),
          ),
          Center(
            child: Text(
              t!.title,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.teal[700],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          Text(
            t.note,
            style: TextStyle(fontSize: 18, height: 1.5, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
