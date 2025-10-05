import 'dart:convert';

class Reminder {
  String id;
  String title;
  bool isCompleted;

  Reminder({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }


  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      title: map['title'],
      isCompleted: map['isCompleted'],
    );
  }

  String toJson() => json.encode(toMap());


  factory Reminder.fromJson(String source) => Reminder.fromMap(json.decode(source));
}
