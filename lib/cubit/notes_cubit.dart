import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/repositories/note_repository.dart';

part 'notes_state.dart';

@injectable
class NotesCubit extends Cubit<NotesState> {
  final NoteRepository noteRepository;
  NotesCubit(this.noteRepository) : super(NotesInitial());

  Future<void> fetchNotes() async {
    emit(NotesLoading());
    final notes = await noteRepository.getAllNotes();
    notes.fold(
      (error) => emit(NotesError(message: error)),
      (result) => emit(NotesLoaded(notes: result)),
    );
  }

  Future<void> addNote(String text) async {
    emit(NotesLoading());
    final result = await noteRepository.addNote(text);
    result.fold(
      (error) => emit(NotesError(message: error)),
      (_) => fetchNotes(),
    );
  }

  Future<void> deleteNote(int noteId) async {
    emit(NotesLoading());
    final result = await noteRepository.deleteNote(noteId);
    result.fold(
        (error) => emit(NotesError(message: error)), (_) => fetchNotes());
  }
}
