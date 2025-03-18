import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Dodaj ten import
import 'package:notes_app/services/auth_service.dart';
import 'package:notes_app/services/supabase_service.dart';
import 'package:notes_app/widgets/login_screen.dart';
import 'package:notes_app/widgets/notes.dart';

void main() async {
  // Upewnij się, że Flutter jest zainicjowany przed Supabase
  WidgetsFlutterBinding.ensureInitialized();

  // Inicjalizacja Supabase
  await Supabase.initialize(
    url: 'https://rjqxcoszkschqdnrriio.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJqcXhjb3N6a3NjaHFkbnJyaWlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzA3NTM1NjUsImV4cCI6MjA0NjMyOTU2NX0.z644HIZnUFUOVQEkNiO0o_ctmWUdEgkwtgiAT_ocYuE',
  );

  final authService = AuthService();
  final supabaseService = SupabaseService(authService);

  runApp(MaterialApp(
    home: LoginScreen(), // Startuje z ekranu logowania
    // TODO: Theming TextButton, TitleFont
  ));
}
