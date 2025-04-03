import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/services/supabase_service.dart';

part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  final SupabaseService supabaseService;

  NotesCubit(this.supabaseService) : super(NotesInitial());

  Future<void> fetchNotes() async {
    emit(NotesLoading());
    try {
      final notes = await supabaseService.fetchNotes();
      emit(NotesLoaded(notes: notes));
    } catch (e) {
      emit(NotesError(message: "Failed to load notes: $e"));
    }
  }

  Future<void> addNote(String text) async {
    try {
      final success = await supabaseService.addNote(text);
      if (success) {
        fetchNotes();
      } else {
        emit(const NotesError(message: "Failed to add note"));
      }
    } catch (e) {
      emit(NotesError(message: "Error adding note $e"));
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      final success = await supabaseService.deleteNote(noteId);
      if (success) {
        fetchNotes();
      } else {
        emit(const NotesError(message: "Failed to delete note"));
      }
    } catch (e) {
      emit(NotesError(message: "Error delete note $e"));
    }
  }
}
