import 'package:dartz/dartz.dart' as dartz;
import 'package:either_dart/either.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/network/api_service.dart';
import 'package:notes_app/network/dio_client.dart';

@injectable
class NoteRepository {
  late final ApiService _apiService;

  NoteRepository(this._apiService);

  Future<Either<String, List<Note>>> getAllNotes() async {
    try {
      final notes = await _apiService.getNotes();
      return Right(notes);
    } catch (e) {
      return const Left("Blad pobierania notatek");
    }
  }

  Future<Either<String, dartz.Unit>> addNote(String text) async {
    try {
      final Map<String, String> noteData = {"text": text};
      await _apiService.addNote(noteData);
      return const Right(dartz.unit);
    } catch (e) {
      return Left("Blad z dodaniem notatki: $e");
    }
  }

  Future<Either<String, dartz.Unit>> deleteNote(int noteId) async {
    try {
      await _apiService.deleteNote('eq.$noteId');
      return const Right(dartz.unit);
    } catch (e) {
      return Left("Blad z usunieciem notatki $e");
    }
  }
}
