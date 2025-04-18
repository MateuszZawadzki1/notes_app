import 'package:flutter/material.dart';
import 'package:notes_app/l10n/l10n_extension.dart';
import 'package:notes_app/src/features/notes/data/models/note.dart';

class NoteItem extends StatelessWidget {
  const NoteItem({
    required this.note,
    required this.onDelete,
    super.key,
  });

  final Note note;
  final Future<void> Function(int) onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 5,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _dialogBuilder(context),
        onLongPress: () => _dialogBuilderRemove(context),
        child: Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${context.l10n.createdby} ${username(note.author!)}',
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "${note.text.replaceAll('\n', ' ').substring(
                      0,
                      note.text.length < 100 ? note.text.length : 100,
                    ).trim()}...",
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
                        username(note.author!),
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
                      ),
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

  Future<void> _dialogBuilderRemove(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Please confirm'),
          content: const Text('Are you sure you want to remove this note?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                onDelete(note.id!);
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}

String toOneLineText(String text) {
  return text.replaceAll('\n', ' ').trim();
}

String username(String text) {
  return text.split('@')[0][0].toUpperCase() + text.split('@')[0].substring(1);
}
