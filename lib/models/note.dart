import 'package:uuid/uuid.dart';

// const uuid = Uuid();

class Note {
  Note({this.id, required this.text, this.author});

  final int? id;
  final String? text;
  final String? author;

  // JSON -> Note
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      text: json['text'] as String? ?? '',
      author: json['author'] as String?,
    );
  }

  // Note -> JSON
  Map<String, dynamic> toJson() {
    return {
      "text": text,
    };
  }
}
