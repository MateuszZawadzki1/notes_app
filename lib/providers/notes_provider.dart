import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/services/supabase_service.dart';

class NotesProvider extends ChangeNotifier {
  final SupabaseService supabaseService;
  List<Note> _notes = [];
  bool _isLoading = false;
  String? _errorMessage;

  NotesProvider(this.supabaseService);

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchNotes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _notes = await supabaseService.fetchNotes();
    } catch (e) {
      _errorMessage = "You cannot fetch notes.";
    }

    _isLoading = false;
    notifyListeners();
  }
}
