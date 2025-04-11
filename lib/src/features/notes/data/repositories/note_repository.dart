import 'package:dartz/dartz.dart' as dartz;
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:notes_app/src/features/notes/data/models/note.dart';
import 'package:notes_app/src/core/services/api_service.dart';

@injectable
class NoteRepository {
  NoteRepository(this._apiService);
  late final ApiService _apiService;

  Future<Either<String, List<Note>>> getAllNotes() async {
    try {
      final notes = await _apiService.getNotes();
      return Right(notes);
    } catch (e) {
      return const Left('Blad pobierania notatek');
    }
  }

  Future<Either<String, dartz.Unit>> addNote(String text) async {
    try {
      final noteData = <String, String>{'text': text};
      await _apiService.addNote(noteData);
      return const Right(dartz.unit);
    } catch (e) {
      return Left('Blad z dodaniem notatki: $e');
    }
  }

  Future<Either<String, dartz.Unit>> deleteNote(int noteId) async {
    try {
      await _apiService.deleteNote('eq.$noteId');
      return const Right(dartz.unit);
    } catch (e) {
      return Left('Blad z usunieciem notatki $e');
    }
  }
}
