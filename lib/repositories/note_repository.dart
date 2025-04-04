import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/network/api_service.dart';
import 'package:notes_app/network/dio_client.dart';

class NoteRepository {
  late final ApiService _apiService;

  NoteRepository() {
    _apiService =
        ApiService(DioClient.getDio(), baseUrl: dotenv.get("REST_URL"));
  }

  Future<List<Note>> getAllNotes() async {
    try {
      return await _apiService.getNotes();
    } catch (e) {
      throw Exception("Blad pobierania notatek");
    }
  }
}
