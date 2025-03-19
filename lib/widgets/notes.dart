import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/services/auth_service.dart';
import 'package:notes_app/services/supabase_service.dart';
import 'package:notes_app/widgets/note_list/note_list.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final SupabaseService _supabaseService = SupabaseService(AuthService());
  List<Note> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    if (_supabaseService.authService.accessToken == null) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      _fetchNotes();
    }
  }

  Future<void> _fetchNotes() async {
    try {
      final notes = await _supabaseService.fetchNotes();
      if (mounted) {
        setState(() {
          _notes = notes ?? [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error: fetch notes $e");
      if (mounted) {
        setState(() {
          _notes = [];
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _addNote(String text) async {
    try {
      final success = await _supabaseService.addNote(text);
      if (success && mounted) {
        await _fetchNotes();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note added successfully')),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add note')),
        );
      }
    } catch (e) {
      print("Error: Add note $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding note: $e')),
        );
      }
    }
  }

  Future<void> _deleteNote(int id) async {
    try {
      final success = await _supabaseService.deleteNote(id.toString());
      if (success && mounted) {
        await _fetchNotes();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note deleted successfully')),
        );
      }
    } catch (e) {
      print("Error: delete note $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting note: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 244, 244),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black,
        title: const Text("Notes", style: TextStyle(color: Colors.blue)),
        leading: PopupMenuButton<String>(
          color: Colors.white,
          itemBuilder: (context) => [
            const PopupMenuItem(
                value: "Log out",
                child: Row(
                  children: [
                    Icon(Icons.logout_outlined),
                    Text("Log out"),
                  ],
                )),
          ],
          icon: const Icon(Icons.menu, color: Colors.blue),
          onSelected: (value) async {
            if (value == "Log out") {
              try {
                await _supabaseService.authService.signOut();
                if (mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                }
              } catch (e) {
                print("Logout error: $e");
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error logging out: $e")));
                }
              }
            }
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(child: NoteList(notes: _notes, onDelete: _deleteNote)),
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
                          icon: const Icon(Icons.add,
                              size: 40, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _dialogBuilderNewNote(BuildContext context) {
    final TextEditingController _noteController = TextEditingController();
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
                const SizedBox(height: 10),
                Expanded(
                  child: TextField(
                    controller: _noteController,
                    maxLines: null,
                    minLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter note text...",
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Cancel",
                          style: TextStyle(color: Colors.blue)),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (_noteController.text.isNotEmpty) {
                          await _addNote(_noteController.text);
                          if (mounted) Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Note cannot be empty')),
                          );
                        }
                      },
                      child: const Text("Add",
                          style: TextStyle(color: Colors.blue)),
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
