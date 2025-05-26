class Titorial {
  int id;
  String title;
  String note;
  int sid;
  int chapter, part;
  // title,note,sid,chapter,part
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

  // Convert Quiz object to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'note': note,
      'sid': sid,
      'chapter': chapter,
      'part': part,
    };
    //name,grade,code,ch
  }

  String printer() {
    return "title = $title note = $note chapter = $chapter   part = $part  sid = $sid";
  }
}
