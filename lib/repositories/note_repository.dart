import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/network/api_service.dart';
import 'package:notes_app/network/dio_client.dart';

@injectable
class NoteRepository {
  late final ApiService _apiService;

  NoteRepository(this._apiService);

  Future<List<Note>> getAllNotes() async {
    try {
      return await _apiService.getNotes();
    } catch (e) {
      throw Exception("Blad pobierania notatek");
    }
  }

  Future<void> addNote(String text) async {
    try {
      final Map<String, String> noteData = {"text": text};
      await _apiService.addNote(noteData);
    } catch (e) {
      throw Exception("Blad dodania notatki");
    }
  }

  Future<void> deleteNote(int noteId) async {
    try {
      await _apiService.deleteNote('eq.$noteId');
    } catch (e) {
      throw Exception("Blad usuwania notatki: $e");
    }
  }
}
