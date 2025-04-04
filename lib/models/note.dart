import 'package:json_annotation/json_annotation.dart';
//import 'package:uuid/uuid.dart';

part 'note.g.dart';

// const uuid = Uuid();

@JsonSerializable()
class Note {
  Note({this.id, required this.text, this.author});

  final int? id;
  final String text;
  final String? author;

  // JSON -> Note
  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  // Note -> JSON
  Map<String, dynamic> toJson() => _$NoteToJson(this);
}
