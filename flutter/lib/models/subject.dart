class Subject {
  int id;
  String name;
  String code;
  int gread;
  int ch;

  Subject({
    this.id = 0,
    required this.name,
    required this.code,
    required this.ch,
    required this.gread,
  });
  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] as int,
      name: json['name'] as String,
      code: json['code'] as String,
      ch: json['ch'] as int,
      gread: json["grade"] as int,
    );
  }

  // Convert Quiz object to JSON
  Map<String, dynamic> toJson() {
    return {'name': name, 'code': code, 'ch': ch, 'grade': gread};
    //name,grade,code,ch
  }

  String printer() {
    return "id = $id name = $name gread = $gread   code = $code ch = $ch";
  }
}
