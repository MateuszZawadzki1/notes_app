import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:notes_app/models/note.dart';
import 'package:notes_app/services/auth_service.dart';

class SupabaseService {
  final String _baseUrl = "https://rjqxcoszkschqdnrriio.supabase.co/auth/v1";
  final String _apiKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJqcXhjb3N6a3NjaHFkbnJyaWlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzA3NTM1NjUsImV4cCI6MjA0NjMyOTU2NX0.z644HIZnUFUOVQEkNiO0o_ctmWUdEgkwtgiAT_ocYuE";

  final AuthService authService;

  SupabaseService(this.authService);

  Future<List<Note>> fetchNotes() async {
    final response = await http.get(
      Uri.parse("$_baseUrl/all_notes"),
      headers: {
        "Content-Type": "application/json",
        "apikey": _apiKey,
        "Authorization": "Bearer ${authService.accessToken}",
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((note) => Note.fromJson(note)).toList();
    } else {
      return [];
    }
  }

  Future<bool> addNote(String text) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/notes"),
      headers: {
        "Content-Type": "application/json",
        "apikey": _apiKey,
        "Authorization": "Bearer ${authService.accessToken}",
      },
      body: jsonEncode({"text": text}),
    );

    return response.statusCode == 201;
  }

  Future<bool> deleteNote(String noteId) async {
    final response =
        await http.delete(Uri.parse("$_baseUrl/notes?id=eq.$noteId"), headers: {
      "Content-Type": "application/json",
      "apikey": _apiKey,
      "Authorization": "Bearer ${authService.accessToken}",
    });

    return response.statusCode == 204;
  }
}
