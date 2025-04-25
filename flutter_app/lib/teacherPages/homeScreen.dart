// ignore: file_names
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(child: _buildWelcomeHeader(context)),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildMetricCard(context, index),
                childCount: 4,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildQuickActions(),
                SizedBox(height: 24),
                _buildRecentSubmissions(),
                SizedBox(height: 24),
                _buildCalendarSection(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good Morning, Prof. Smith',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        // Text(
        //   'Today: ${DateFormat('EEEE, MMMM d').format(DateTime.now())}',
        //   style: Theme.of(context).textTheme.titleMedium?.copyWith(
        //         color: Colors.grey[600],
        //       ),
        // ),
      ],
    );
  }

  Widget _buildMetricCard(BuildContext context, int index) {
    final metrics = [
      {
        'title': 'Total Students',
        'value': '142',
        'icon': Icons.people_alt,
        'color': Colors.blue,
      },
      {
        'title': 'Pending Quizzes',
        'value': '5',
        'icon': Icons.quiz,
        'color': Colors.orange,
      },
      {
        'title': 'Unread Messages',
        'value': '3',
        'icon': Icons.markunread,
        'color': Colors.green,
      },
      {
        'title': 'Recent Uploads',
        'value': '2',
        'icon': Icons.upload,
        'color': Colors.purple,
      },
    ];

    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              metrics[index]['icon'] as IconData,
              size: 32,
              color: metrics[index]['color'] as Color,
            ),
            SizedBox(height: 12),
            Text(
              metrics[index]['value'].toString(),
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              metrics[index]['title'].toString(),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          childAspectRatio: 1.1,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            _buildActionButton(Icons.add, 'New Quiz', Colors.blue, () {}),
            _buildActionButton(
              Icons.upload,
              'Upload Material',
              Colors.green,
              () {},
            ),
            _buildActionButton(
              Icons.campaign,
              'Send Announcement',
              Colors.orange,
              () {},
            ),
            _buildActionButton(
              Icons.assignment,
              'Create Assignment',
              Colors.purple,
              () {},
            ),
            _buildActionButton(
              Icons.schedule,
              'Schedule Class',
              Colors.teal,
              () {},
            ),
            _buildActionButton(
              Icons.analytics,
              'View Reports',
              Colors.red,
              () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSubmissions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Submissions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(onPressed: () {}, child: Text('View All')),
          ],
        ),
        SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder:
                (context, index) => ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text('Student ${index + 1}'),
                  subtitle: Text('Mathematics Quiz - 2 hours ago'),
                  trailing: Icon(
                    Icons.assignment_turned_in,
                    color: Colors.green,
                  ),
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming Schedule',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(onPressed: () {}, child: Text('View Calendar')),
          ],
        ),
        SizedBox(height: 12),
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ListView(
            padding: EdgeInsets.all(12),
            children: [
              _buildCalendarEvent('Class 9A - Mathematics', 'Mon, 10:00 AM'),
              _buildCalendarEvent('Staff Meeting', 'Tue, 2:00 PM'),
              _buildCalendarEvent('Parent-Teacher Meeting', 'Wed, 11:00 AM'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarEvent(String title, String time) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
              Text(time, style: TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
