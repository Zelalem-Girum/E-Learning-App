import 'package:intl/intl.dart';

class Assignment {
  final String title;
  final int id;
  final String description;
  final int subject;
  final DateTime dueDate;
  final DateTime created_at;

  Assignment({
    required this.title,
    required this.created_at,
    required this.description,
    required this.subject,
    required this.dueDate,
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'id': id,
      'description': description,
      'subject': subject,
      'dueDate': dueDate.toIso8601String(),
    };
  }

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      title: json['title'] as String,
      id: json['id'],
      description: json['description'] as String,
      subject: json['subject'] as int,
      dueDate: DateTime.parse(json['due_date'] as String),
      created_at: DateTime.parse(json['created_at'] as String),
    );
  }
  String toString() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    return 'Assignment(title: $title, description: $description, subject: $subject, dueDate: ${formatter.format(dueDate)})';
  }
}
