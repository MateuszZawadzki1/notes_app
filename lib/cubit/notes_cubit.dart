import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/repositories/note_repository.dart';

part 'notes_state.dart';

@injectable
class NotesCubit extends Cubit<NotesState> {
  //final SupabaseService supabaseService;
  final NoteRepository noteRepository;
  NotesCubit(this.noteRepository) : super(NotesInitial());

  Future<void> fetchNotes() async {
    emit(NotesLoading());
    try {
      final notes = await noteRepository.getAllNotes();
      emit(NotesLoaded(notes: notes));
    } catch (e) {
      emit(NotesError(message: "Failed to load notes: $e"));
    }
  }

  Future<void> addNote(String text) async {
    emit(NotesLoading());
    try {
      await noteRepository.addNote(text);
      final notes = await noteRepository.getAllNotes();
      emit(NotesLoaded(notes: notes));
    } catch (e) {
      emit(NotesError(message: "Error adding note $e"));
    }
  }

  Future<void> deleteNote(int noteId) async {
    emit(NotesLoading());
    try {
      await noteRepository.deleteNote(noteId);
      final notes = await noteRepository.getAllNotes();
      emit(NotesLoaded(notes: notes));
    } catch (e) {
      emit(NotesError(message: "Error delete note $e"));
    }
  }
}
