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
        onLongPress: () => _dialogBuilderRemove(context),
        child: Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Created by: ${note.user}",
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "${note.text.substring(0, note.text.length < 100 ? note.text.length : 100)}...",
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
        return Dialog(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        note.user,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 24,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.blue,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(note.text),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Future<void> _dialogBuilderRemove(BuildContext context) {
  return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Please confirm"),
          content: const Text("Are you sure you want to remove this note?"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("No")),
            TextButton(onPressed: () {}, child: const Text("Yes"))
          ],
        );
      });
}
