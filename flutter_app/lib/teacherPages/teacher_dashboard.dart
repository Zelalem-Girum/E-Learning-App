import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_app/teacherPages/homeScreen.dart';
import 'package:image_picker/image_picker.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TeacherDashboardState createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    StudentProgressScreen(),
    QuizManagementScreen(),
    MaterialsScreen(),
    ChatScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Teacher Dashboard'),
        actions: [IconButton(icon: Icon(Icons.logout), onPressed: _logout)],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Students'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Quizzes'),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: 'Materials',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        ],
      ),
    );
  }

  void _logout() {
    // Implement logout logic
  }
}

// Student Progress Tracking Screen
class StudentProgressScreen extends StatelessWidget {
  const StudentProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('students').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var student = snapshot.data!.docs[index];
            return ListTile(
              title: Text(student['name']),
              subtitle: LinearProgressIndicator(
                value: student['progress'] / 100,
              ),
              trailing: Text('${student['progress']}%'),
            );
          },
        );
      },
    );
  }
}

// Quiz Management Screen
class QuizManagementScreen extends StatefulWidget {
  const QuizManagementScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _QuizManagementScreenState createState() => _QuizManagementScreenState();
}

class _QuizManagementScreenState extends State<QuizManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          // Existing quizzes
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('quizzes').snapshots(),
            builder: (context, snapshot) {
              return Text("Hi");
              // Display quizzes list
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showAddQuizDialog(context),
      ),
    );
  }

  void _showAddQuizDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Add New Quiz'),
            content: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _questionController,
                    decoration: InputDecoration(labelText: 'Question'),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  // Add more fields for options and correct answer
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(onPressed: _submitQuiz, child: Text('Save')),
            ],
          ),
    );
  }

  void _submitQuiz() {
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore.instance.collection('quizzes').add({
        'question': _questionController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      Navigator.pop(context);
    }
  }
}

// Teaching Materials Screen
class MaterialsScreen extends StatefulWidget {
  const MaterialsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MaterialsScreenState createState() => _MaterialsScreenState();
}

class _MaterialsScreenState extends State<MaterialsScreen> {
  final _storage = FirebaseStorage.instance;
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: 0, // Replace with actual data
        itemBuilder:
            (context, index) => MaterialCard(
              title: '',
              date: '',
              fileType: '',
              onView: () {},
              onDelete: () {},
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadMaterial,
        child: Icon(Icons.upload),
      ),
    );
  }

  Future<void> _uploadMaterial() async {
    final file = await _picker.pickVideo(source: ImageSource.gallery);
    if (file != null) {
      final ref = _storage.ref().child('materials/${DateTime.now()}.mp4');
      await ref.putFile(File(file.path));
    }
  }
}

class MaterialCard extends StatelessWidget {
  final String title;
  final String date;
  final String fileType;
  final String? thumbnailUrl;
  final VoidCallback onView;
  final VoidCallback onDelete;

  const MaterialCard({
    super.key,
    required this.title,
    required this.date,
    required this.fileType,
    this.thumbnailUrl,
    required this.onView,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          // Thumbnail/Preview
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: Colors.grey[100],
              child:
                  thumbnailUrl != null
                      ? Image.network(
                        thumbnailUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 150,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value:
                                  loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                            ),
                          );
                        },
                        errorBuilder:
                            (context, error, stackTrace) =>
                                _buildFallbackPreview(),
                      )
                      : _buildFallbackPreview(),
            ),
          ),

          // Content Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
          ),

          // Content
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _getFileTypeIcon(),
                          color: Colors.white70,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          fileType.toUpperCase(),
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                    Text(
                      date,
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Context Menu
          Positioned(
            top: 8,
            right: 8,
            child: PopupMenuButton(
              icon: Icon(Icons.more_vert, color: Colors.white),
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.visibility),
                        title: Text('View'),
                        onTap: onView,
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.delete, color: Colors.red),
                        title: Text('Delete'),
                        onTap: onDelete,
                      ),
                    ),
                  ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackPreview() {
    return Container(
      width: double.infinity,
      height: 150,
      alignment: Alignment.center,
      child: Icon(_getFileTypeIcon(), size: 48, color: Colors.grey[400]),
    );
  }

  IconData _getFileTypeIcon() {
    switch (fileType.toLowerCase()) {
      case 'video':
        return Icons.videocam;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'document':
        return Icons.description;
      case 'image':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }
}

// Chat Screen
class ChatScreen extends StatelessWidget {
  final _messageController = TextEditingController();

  ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance
                    .collection('chats')
                    .orderBy('timestamp')
                    .snapshots(),
            builder: (context, snapshot) {
              return Text("Hello");
              // Display messages
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(hintText: 'Type a message...'),
                ),
              ),
              IconButton(icon: Icon(Icons.send), onPressed: _sendMessage),
            ],
          ),
        ),
      ],
    );
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('chats').add({
        'message': _messageController.text,
        'sender': 'teacher',
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
    }
  }
}
