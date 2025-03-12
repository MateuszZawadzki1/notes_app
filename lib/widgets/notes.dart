import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/services/auth_service.dart';
import 'package:notes_app/services/supabase_service.dart';
import 'package:notes_app/widgets/note_list/note_list.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() {
    return _NotesState();
  }
}

class _NotesState extends State<Notes> {
  final SupabaseService _supabaseService = SupabaseService(AuthService());
  List<Note> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    try {
      final notes = await _supabaseService.fetchNotes();
      setState(() {
        _notes = notes;
        _isLoading = false;
      });
    } catch (e) {
      print("Error: fetch notes $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addNote(String text) async {
    try {
      await _supabaseService.addNote(text);
      _fetchNotes();
    } catch (e) {
      print("Error: Add note $e");
    }
  }

  Future<void> _deleteNote(int id) async {
    try {
      await _supabaseService.deleteNote(id.toString());
      _fetchNotes();
    } catch (e) {
      print("Error: delete note $e");
    }
  }

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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(child: NoteList(notes: _notes, onDelete: _deleteNote)),
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
    TextEditingController _noteController = TextEditingController();

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
                const Row(
                  children: [
                    Text(
                      "Add new note",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: TextField(
                    controller: _noteController,
                    maxLines: null,
                    minLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
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
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (_noteController.text.isNotEmpty) {
                          _addNote(_noteController.text);
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text(
                        "Add",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
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
