import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';

class NoteItem extends StatelessWidget {
  const NoteItem(this.note, {super.key});

  final Note note;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: GestureDetector(
        onTap: () => _dialogBuilder(context),
        onLongPress: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Created by: ${note.user}",
                style: const TextStyle(color: Colors.blue),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "${note.text.substring(0, note.text.length < 80 ? note.text.length : 80)}...",
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: AppBar(
            title: Text(
              note.user,
            ),
            automaticallyImplyLeading: false,
            actions: [
              const SizedBox(
                width: 20,
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          content: Text(note.text),
        );
      },
    );
  }
}
