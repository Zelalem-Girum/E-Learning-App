import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_tts/flutter_tts.dart';

// Titorial class as provided
class Titorial {
  int id;
  String title;
  String note;
  int sid;
  int chapter, part;

  Titorial({
    this.id = 0,
    required this.title,
    required this.note,
    required this.sid,
    required this.chapter,
    required this.part,
  });

  factory Titorial.fromJson(Map<String, dynamic> json) {
    return Titorial(
      id: json['id'] as int,
      title: json['title'] as String,
      note: json['note'] as String,
      sid: json['sid'] as int,
      chapter: json['chapter'] as int,
      part: json['part'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'note': note,
      'sid': sid,
      'chapter': chapter,
      'part': part,
    };
  }
}

void main() {
  runApp(const Grade1MathApp());
}

class Grade1MathApp extends StatelessWidget {
  const Grade1MathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grade 1 Mathematics Course',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Roboto'),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedGrade = 1; // Default to Grade 1
  final List<int> grades = List.generate(
    10,
    (i) => i + 1,
  ); // Predefined grades: [1, 2, ..., 10]

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grade 1 Mathematics'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course Header
              const Text(
                'Welcome to Grade 1 Mathematics!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Learn math with fun videos and questions!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Grade Selector Dropdown
              const Text(
                'Select Grade',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                value: selectedGrade,
                onChanged: (int? newValue) {
                  setState(() {
                    selectedGrade = newValue!;
                  });
                },
                items:
                    grades.map<DropdownMenuItem<int>>((int grade) {
                      return DropdownMenuItem<int>(
                        value: grade,
                        child: Text('Grade $grade'),
                      );
                    }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Grade',
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
                hint: const Text('Choose a Grade'),
              ),
              const SizedBox(height: 20),

              // Navigate to Titorial List
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TitorialListScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'View Tutorials',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),

              // Learning Modules (only for Grade 1)
              if (selectedGrade == 1) ...[
                const Text(
                  'Learning Modules',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ModuleCard(
                  title: 'Module 1: Numbers and Counting',
                  videoUrl:
                      'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
                  question: 'What is ${grades[4]} + 1?', // Uses grades[4] = 5
                  options: const ['4', '5', '6', '7'],
                  correctAnswer: '6',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ModuleDetailScreen(
                              moduleTitle: 'Numbers and Counting',
                              videoUrl:
                                  'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
                              question: 'What is ${grades[4]} + 1?',
                              options: const ['4', '5', '6', '7'],
                              correctAnswer: '6',
                            ),
                      ),
                    );
                  },
                ),
                ModuleCard(
                  title: 'Module 2: Addition and Subtraction',
                  videoUrl:
                      'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
                  question: 'What is 10 - 4?',
                  options: const ['4', '5', '6', '7'],
                  correctAnswer: '6',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ModuleDetailScreen(
                              moduleTitle: 'Addition and Subtraction',
                              videoUrl:
                                  'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
                              question: 'What is 10 - 4?',
                              options: const ['4', '5', '6', '7'],
                              correctAnswer: '6',
                            ),
                      ),
                    );
                  },
                ),
                ModuleCard(
                  title: 'Module 3: Shapes and Patterns',
                  videoUrl:
                      'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
                  question: 'What shape has 3 sides?',
                  options: const ['Circle', 'Triangle', 'Square', 'Rectangle'],
                  correctAnswer: 'Triangle',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ModuleDetailScreen(
                              moduleTitle: 'Shapes and Patterns',
                              videoUrl:
                                  'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
                              question: 'What shape has 3 sides?',
                              options: const [
                                'Circle',
                                'Triangle',
                                'Square',
                                'Rectangle',
                              ],
                              correctAnswer: 'Triangle',
                            ),
                      ),
                    );
                  },
                ),
                ModuleCard(
                  title: 'Module 4: Measurement and Time',
                  videoUrl:
                      'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
                  question: 'What time is 12:00?',
                  options: const ['Midnight', 'Noon', 'Morning', 'Evening'],
                  correctAnswer: 'Noon',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ModuleDetailScreen(
                              moduleTitle: 'Measurement and Time',
                              videoUrl:
                                  'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
                              question: 'What time is 12:00?',
                              options: const [
                                'Midnight',
                                'Noon',
                                'Morning',
                                'Evening',
                              ],
                              correctAnswer: 'Noon',
                            ),
                      ),
                    );
                  },
                ),
              ] else ...[
                const Text(
                  'This course is designed for Grade 1. Please select Grade 1 to view modules.',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ModuleCard extends StatelessWidget {
  final String title;
  final String videoUrl;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final VoidCallback onTap;

  const ModuleCard({
    super.key,
    required this.title,
    required this.videoUrl,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Watch a fun video and answer a question!',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ModuleDetailScreen extends StatefulWidget {
  final String moduleTitle;
  final String videoUrl;
  final String question;
  final List<String> options;
  final String correctAnswer;

  const ModuleDetailScreen({
    super.key,
    required this.moduleTitle,
    required this.videoUrl,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  @override
  _ModuleDetailScreenState createState() => _ModuleDetailScreenState();
}

class _ModuleDetailScreenState extends State<ModuleDetailScreen> {
  late VideoPlayerController _controller;
  late FlutterTts _tts;
  bool _isVideoInitialized = false;
  bool _isQuestionAnswered = false;
  bool _isCorrect = false;
  String? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
        });
        _controller.play();
      });

    _tts = FlutterTts();
    _speakQuestion();
  }

  Future<void> _speakQuestion() async {
    await _tts.setLanguage('en-US');
    await _tts.setPitch(1.0);
    await _tts.speak(widget.question);
  }

  @override
  void dispose() {
    _controller.dispose();
    _tts.stop();
    super.dispose();
  }

  void _checkAnswer(String answer) {
    setState(() {
      _selectedAnswer = answer;
      _isQuestionAnswered = true;
      _isCorrect = answer == widget.correctAnswer;
    });
    _tts.speak(
      _isCorrect ? 'Great job! That is correct!' : 'Oops, try again next time!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.moduleTitle), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _isVideoInitialized
                  ? Column(
                    children: [
                      AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: Text(
                          _controller.value.isPlaying ? 'Pause' : 'Play',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                  : const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 20),
              Text(
                widget.question,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _speakQuestion,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                child: const Text(
                  'Listen Again',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              ...widget.options.map(
                (option) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ElevatedButton(
                    onPressed:
                        _isQuestionAnswered ? null : () => _checkAnswer(option),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _selectedAnswer == option
                              ? (_isCorrect ? Colors.green : Colors.red)
                              : Colors.blue,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(
                      option,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
              if (_isQuestionAnswered) ...[
                const SizedBox(height: 20),
                Text(
                  _isCorrect ? 'Great job!' : 'Try again next time!',
                  style: TextStyle(
                    fontSize: 16,
                    color: _isCorrect ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_isCorrect) ...[
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class TitorialListScreen extends StatefulWidget {
  const TitorialListScreen({super.key});

  @override
  _TitorialListScreenState createState() => _TitorialListScreenState();
}

class _TitorialListScreenState extends State<TitorialListScreen> {
  // Sample list of Titorial objects
  List<Titorial> titorials = [
    Titorial(
      id: 1,
      title: 'Counting to 10',
      note: 'Learn basic counting',
      sid: 1,
      chapter: 1,
      part: 1,
    ),
    Titorial(
      id: 2,
      title: 'Addition Basics',
      note: 'Introduction to addition',
      sid: 1,
      chapter: 1,
      part: 2,
    ),
    Titorial(
      id: 3,
      title: 'Shapes Introduction',
      note: 'Learn about 2D shapes',
      sid: 1,
      chapter: 2,
      part: 1,
    ),
  ];

  void _editTitorial(Titorial titorial) {
    // Placeholder for edit action
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Editing ${titorial.title}')));
    // TODO: Navigate to an edit screen with titorial data
  }

  void _deleteTitorial(Titorial titorial) {
    setState(() {
      titorials.remove(titorial);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${titorial.title} deleted')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutorials'),
        centerTitle: true,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TitorialListScreen(),
                ),
              );
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: DataTable(
              columns: const [
                DataColumn(
                  label: Text(
                    'ID',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Title',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Note',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'SID',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Chapter',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Part',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Actions',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows:
                  titorials.map((titorial) {
                    return DataRow(
                      cells: [
                        DataCell(Text(titorial.id.toString())),
                        DataCell(Text(titorial.title)),
                        DataCell(Text(titorial.note)),
                        DataCell(Text(titorial.sid.toString())),
                        DataCell(Text(titorial.chapter.toString())),
                        DataCell(Text(titorial.part.toString())),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () => _editTitorial(titorial),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _deleteTitorial(titorial),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
