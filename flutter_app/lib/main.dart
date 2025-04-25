import 'package:flutter/material.dart';
import 'package:flutter_app/landing_page.dart';

void main() {
  runApp(HomePage());
}

// class EducationApp extends StatelessWidget {
//   const EducationApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Ethiopian E-Learning',
//       theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Roboto'),
//       home: HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Ethiopian E-Learning'),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Greeting Section
//               Text(
//                 'Welcome, Student!',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'What would you like to learn today?',
//                 style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//               ),
//               SizedBox(height: 20),

//               // Features Grid
//               GridView.count(
//                 crossAxisCount: 2,
//                 shrinkWrap: true,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//                 physics: NeverScrollableScrollPhysics(),
//                 children: [
//                   _buildFeatureCard(
//                     context,
//                     'Video Tutorials',
//                     Icons.play_circle_fill,
//                     Colors.blue,
//                     () => Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => VideoScreen()),
//                     ),
//                   ),
//                   _buildFeatureCard(
//                     context,
//                     'Quizzes',
//                     Icons.quiz,
//                     Colors.green,
//                     () => Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => QuizScreen()),
//                     ),
//                   ),
//                   _buildFeatureCard(
//                     context,
//                     'Interactive STEM',
//                     Icons.science,
//                     Colors.orange,
//                     () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => InteractiveScreen(),
//                       ),
//                     ),
//                   ),
//                   _buildFeatureCard(
//                     context,
//                     'Ask a Teacher',
//                     Icons.chat,
//                     Colors.purple,
//                     () => Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => ChatScreen()),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFeatureCard(
//     BuildContext context,
//     String title,
//     IconData icon,
//     Color color,
//     VoidCallback onTap,
//   ) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           // ignore: deprecated_member_use
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: color, width: 1),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(icon, size: 40, color: color),
//               SizedBox(height: 10),
//               Text(
//                 title,
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class VideoScreen extends StatelessWidget {
//   const VideoScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Video Tutorials')),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: 10,
//         itemBuilder: (context, index) {
//           return Card(
//             elevation: 2,
//             margin: const EdgeInsets.only(bottom: 16),
//             child: ListTile(
//               leading: Icon(Icons.play_circle, color: Colors.blue, size: 40),
//               title: Text('Lesson ${index + 1}: Topic Title'),
//               subtitle: Text('Grade 8 - Mathematics'),
//               trailing: Icon(Icons.arrow_forward_ios, size: 16),
//               onTap: () {},
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class QuizScreen extends StatelessWidget {
//   const QuizScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Quizzes')),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: 10,
//         itemBuilder: (context, index) {
//           return Card(
//             elevation: 2,
//             margin: const EdgeInsets.only(bottom: 16),
//             child: ListTile(
//               leading: Icon(Icons.quiz, color: Colors.green, size: 40),
//               title: Text('Quiz ${index + 1}: Topic Name'),
//               subtitle: Text('Grade 9 - Physics'),
//               trailing: Icon(Icons.arrow_forward_ios, size: 16),
//               onTap: () {
//                 // Navigate to quiz page
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class InteractiveScreen extends StatelessWidget {
//   const InteractiveScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Interactive STEM Content')),
//       body: Center(
//         child: Text(
//           'Interactive STEM content coming soon!',
//           style: TextStyle(fontSize: 18, color: Colors.grey[600]),
//         ),
//       ),
//     );
//   }
// }

// class ChatScreen extends StatelessWidget {
//   const ChatScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Ask a Teacher')),
//       body: Center(
//         child: Text(
//           'Chat with a teacher feature coming soon!',
//           style: TextStyle(fontSize: 18, color: Colors.grey[600]),
//         ),
//       ),
//     );
//   }
// }
