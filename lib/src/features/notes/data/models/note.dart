import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
//import 'package:uuid/uuid.dart';

part 'note.g.dart';

// const uuid = Uuid();

@HiveType(typeId: 0)
@JsonSerializable()
class Note {
  Note({
    required this.text,
    this.id,
    this.author,
    this.needsSync = false,
  });

  // JSON -> Note
  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String text;
  @HiveField(2)
  final String? author;
  @HiveField(3)
  final bool needsSync;

  // Note -> JSON
  Map<String, dynamic> toJson() => _$NoteToJson(this);
}
