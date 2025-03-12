import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/widgets/note_list/note_item.dart';

class NoteList extends StatelessWidget {
  const NoteList({
    super.key,
    required this.notes,
    required this.onDelete,
  });

  final List<Note> notes;
  final Function(int) onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(notes[index].id),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 30,
          ),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          onDelete(notes[index].id!);
        },
        child: NoteItem(note: notes[index], onDelete: onDelete),
      ),
    );
  }
}
