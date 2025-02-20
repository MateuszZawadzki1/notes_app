import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Note {
  Note({required this.user, required this.text}) : id = uuid.v4();

  final String id;
  final String user;
  final String text;
}
