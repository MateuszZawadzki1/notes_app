import 'package:uuid/uuid.dart';

// const uuid = Uuid();

class Note {
  Note({this.id, required this.user, required this.text});

  final int? id;
  final String user;
  final String text;

  // JSON -> Note
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      user: json['user'],
      text: json['text'],
    );
  }

  // Note -> JSON
  Map<String, dynamic> toJson() {
    return {
      "user": user,
      "text": text,
    };
  }
}
