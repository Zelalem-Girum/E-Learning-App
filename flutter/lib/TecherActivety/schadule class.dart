import 'package:flutter/material.dart';

void main() {
  runApp(ClassScheduleApp());
}

class ClassScheduleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Class Schedule',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ScheduleHomePage(),
    );
  }
}

class Schedule {
  final String subject;
  final String time;
  final String day;

  Schedule({required this.subject, required this.time, required this.day});
}

class ScheduleHomePage extends StatefulWidget {
  @override
  _ScheduleHomePageState createState() => _ScheduleHomePageState();
}

class _ScheduleHomePageState extends State<ScheduleHomePage> {
  List<Schedule> schedules = [];

  void addSchedule(String subject, String time, String day) {
    setState(() {
      schedules.add(Schedule(subject: subject, time: time, day: day));
    });
  }

  void showAddScheduleDialog() {
    final _subjectController = TextEditingController();
    final _timeController = TextEditingController();
    String selectedDay = 'Monday';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Class Schedule'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _subjectController,
                decoration: InputDecoration(labelText: 'Subject'),
              ),
              TextField(
                controller: _timeController,
                decoration: InputDecoration(labelText: 'Time (e.g. 9:00 AM)'),
              ),
              DropdownButton<String>(
                value: selectedDay,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedDay = value;
                    });
                  }
                },
                items:
                    [
                      'Monday',
                      'Tuesday',
                      'Wednesday',
                      'Thursday',
                      'Friday',
                      'Saturday',
                      'Sunday',
                    ].map((day) {
                      return DropdownMenuItem(value: day, child: Text(day));
                    }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                addSchedule(
                  _subjectController.text,
                  _timeController.text,
                  selectedDay,
                );
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Schedule>> groupedSchedules = {};

    for (var schedule in schedules) {
      groupedSchedules.putIfAbsent(schedule.day, () => []).add(schedule);
    }

    return Scaffold(
      appBar: AppBar(title: Text('Class Schedule')),
      body:
          schedules.isEmpty
              ? Center(child: Text('No classes added. Tap + to add one.'))
              : ListView(
                children:
                    groupedSchedules.entries.map((entry) {
                      return ExpansionTile(
                        title: Text(entry.key),
                        children:
                            entry.value.map((sched) {
                              return ListTile(
                                title: Text(sched.subject),
                                subtitle: Text(sched.time),
                              );
                            }).toList(),
                      );
                    }).toList(),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddScheduleDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
