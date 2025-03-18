import 'package:uuid/uuid.dart';

// const uuid = Uuid();

class Note {
  Note({this.id, required this.text});

  final int? id;
  final String? text;

  // JSON -> Note
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      text: json['text'] as String? ?? '',
    );
  }

  // Note -> JSON
  Map<String, dynamic> toJson() {
    return {
      "text": text,
    };
  }
}
