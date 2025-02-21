import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/widgets/note_list/note_list.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() {
    return _NotesState();
  }
}

class _NotesState extends State<Notes> {
  final List<Note> _registeredNotes = [
    Note(
        user: "John Doe",
        text:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vitae aliquet urna, ac hendrerit felis. Quisquetincidunt mi sed ipsum ullamcorper, quis posuere purus molestie. Curabitur lacinia posuere metus quis gravida. Nam a erat libero. Integer eu ullamcorper leo, et mattis sem. Quisque nibh massa, pulvinar in varius tempor, mollis ut felis. Pellentesque in tortor nec massa fermentum porta.")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notes",
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
        leading: PopupMenuButton<String>(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: "Log out",
              child: Text("Log out"),
            ),
          ],
          icon: const Icon(
            Icons.menu,
            color: Colors.blue,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: NoteList(notes: _registeredNotes)),
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.only(right: 30, bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Ink(
                  decoration: const ShapeDecoration(
                    color: Colors.blue,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    onPressed: () => _dialogBuilderNewNote(context),
                    icon: const Icon(
                      Icons.add,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _dialogBuilderNewNote(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  "Add new note",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Expanded(
                  child: TextField(
                    maxLines: null,
                    minLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter note text..."),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text("Add"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
