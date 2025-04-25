import 'package:flutter/material.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          "E-Learning App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting and Welcome Message
              Text(
                "Hello, Student!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                "Continue learning with your personalized recommendations.",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 20),

              // Categories Section
              Text(
                "Categories",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              GridView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 3 / 2,
                ),
                children: [
                  _buildCategoryCard(
                    icon: Icons.play_circle_fill,
                    label: "Videos",
                    color: Colors.blue,
                  ),
                  _buildCategoryCard(
                    icon: Icons.quiz,
                    label: "Quizzes",
                    color: Colors.orange,
                  ),
                  _buildCategoryCard(
                    icon: Icons.science,
                    label: "STEM Interactive",
                    color: Colors.purple,
                  ),
                  _buildCategoryCard(
                    icon: Icons.chat,
                    label: "Ask a Teacher",
                    color: Colors.green,
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Personalized Recommendations Section
              Text(
                "Recommended for You",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5, // Example: 5 personalized recommendations
                itemBuilder: (context, index) {
                  return _buildRecommendationCard(
                    title: "Lesson ${index + 1}: Introduction to Science",
                    description:
                        "Explore the basics of science with engaging videos and activities.",
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for Category Card
  Widget _buildCategoryCard({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        // Handle category navigation
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for Recommendation Card
  Widget _buildRecommendationCard({
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.lightbulb, color: Colors.yellow[700], size: 40),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          description,
          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
        onTap: () {
          // Handle recommendation navigation
        },
      ),
    );
  }
}

// void main() => runApp(MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: StudentDashboard(),
//     ));
