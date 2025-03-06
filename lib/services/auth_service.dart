import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {
  final String _baseUrl = "https://rjqxcoszkschqdnrriio.supabase.co";
  final String _apiKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJqcXhjb3N6a3NjaHFkbnJyaWlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzA3NTM1NjUsImV4cCI6MjA0NjMyOTU2NX0.z644HIZnUFUOVQEkNiO0o_ctmWUdEgkwtgiAT_ocYuE";

  String? accessToken;

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/token?grant_type=password"),
      headers: {
        "Content-type": "application/json",
        "apikey": _apiKey,
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      accessToken = data["access_token"];
      return true;
    } else {
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/signup"),
      headers: {
        "Content-Type": "application/json",
        "apikey": _apiKey,
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );
    return response.statusCode == 200;
  }
}
