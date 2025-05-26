class Message {
  String message;
  String emailin;
  String emailout;
  int id;

  Message({
    required this.message,
    required this.emailout,
    required this.id,
    required this.emailin,
  });
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      emailout: json['emailout'] as String,
      message: json['message'] as String,
      emailin: json['emailin'] as String,
      id: json['id'] as int,
    );
  }

  // Convert Quiz object to JSON
  Map<String, dynamic> toJson() {
    return {'message': message, 'emailin': emailin, 'emailout': emailout};
  }

  String printer() {
    return "type = $emailout message = $message";
  }
}
