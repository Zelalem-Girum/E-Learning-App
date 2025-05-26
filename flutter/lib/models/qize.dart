class Quiz {
  int id;
  String type;
  String question;
  List<String> options;
  dynamic answer;
  int subject;

  Quiz({
    required this.id,
    required this.type,
    required this.question,
    this.options = const [],
    required this.answer,
    required this.subject,
  });
  factory Quiz.fromJson(Map<String, dynamic> json) {
    String option = json['choices'];
    String type = json['questiontype'];
    return Quiz(
      id: json['id'] as int,
      type: json['questiontype'] as String,
      question: json['question'] as String,
      options: type != "truefalse" ? option.split(",").toList() : [],
      answer: json["answer"],
      subject: json["subjectid"] as int,
    );
  }

  // Convert Quiz object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questiontype': type,
      'question': question,
      'choices': options.join(','),
      'subjectid': subject,
      'answer': answer.toString(),
    };
  }

  String printer() {
    return "type = $type quetion = $question option = $options  subjectid = $subject answer = $answer";
  }
}
