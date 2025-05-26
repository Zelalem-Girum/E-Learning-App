import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v1/studentActivity/appbar.dart';
import 'package:v1/models/message.dart';

class ChatScreen1 extends StatefulWidget {
  @override
  _ChatScreen1State createState() => _ChatScreen1State();
}

class _ChatScreen1State extends State<ChatScreen1> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];
  bool isloding = true;
  String myemail = "";
  late String custmeremail;
  bool ised = false;
  @override
  void initState() {
    super.initState();
    tast();
  }

  void tast() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      myemail = prefs.getString("emailout")!;
      custmeremail = prefs.getString("emailin")!;
    });
    // print("My Emaile is = $myemail");
    // print("Custmer Emaile is =$custmeremail");
    fetchSubjects();
  }

  Future<void> fetchSubjects() async {
    // print(_messages.length);
    try {
      // print(myemail);
      // print('http://localhost:8800/reports/$myemail');
      final response = await http.get(
        Uri.parse('http://localhost:8800/reports/$myemail/$custmeremail'),
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        List<dynamic> data = jsonDecode(response.body);
        var lists = data.map((json) => Message.fromJson(json)).toList();
        // print(lists.length);
        setState(() {
          isloding = false;
          _messages.addAll(lists);
          // for (Quiz q in lists) print(q.printer());
        });
      }
      // print("length of quize =${quizzes.length}");
    } catch (e) {}
    // print("message  length = ${_messages.length}");
  }

  Future<void> _sendMessage() async {
    final text = _controller.text;
    Message mess = new Message(
      message: text,
      emailout: custmeremail,
      id: 0,
      emailin: myemail,
    );
    if (text.isNotEmpty) {
      final response = await http.post(
        Uri.parse('http://localhost:8800/reports/'),
        headers: {
          'Content-Type':
              'application/json', // Tell the server we're sending JSON
        },
        body: jsonEncode(mess.toJson()), // Convert quiz to JSON string
      );
      if (response.statusCode == 200) {
        print("sended message");
        setState(() {
          _messages.insert(
            0,
            Message(
              message: text,
              emailout: custmeremail,
              id: 1,
              emailin: myemail,
            ),
          );
          _controller.clear();
        });
      }
    }
  }

  Widget _buildMessage(Message message) {
    return isloding
        ? CircularProgressIndicator(color: Colors.blue)
        : Align(
          alignment:
              myemail != message.emailin
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  myemail != message.emailin
                      ? Colors.blue[200]
                      : const Color.fromARGB(255, 116, 243, 104),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(message.message),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      body: Column(
        children: [
          TopBare(),
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    keyboardType: TextInputType.multiline,
                    minLines: 1, // minimum number of lines
                    maxLines:
                        5, // maximum number of lines (set null for infinite)
                  ),
                ),
                IconButton(icon: Icon(Icons.send), onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
