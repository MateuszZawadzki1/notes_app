import 'package:json_annotation/json_annotation.dart';
//import 'package:uuid/uuid.dart';

part 'note.g.dart';

// const uuid = Uuid();

@JsonSerializable()
class Note {
  Note({required this.text, this.id, this.author});

  // JSON -> Note
  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  final int? id;
  final String text;
  final String? author;

  // Note -> JSON
  Map<String, dynamic> toJson() => _$NoteToJson(this);
}
