import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/widgets/note_list/note_item.dart';

class NoteList extends StatelessWidget {
  const NoteList({
    super.key,
    required this.notes,
  });

  final List<Note> notes;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(notes[index]),
        child: NoteItem(
          notes[index],
        ),
      ),
    );
  }
}
