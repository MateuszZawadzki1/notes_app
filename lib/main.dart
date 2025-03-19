import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:notes_app/services/auth_service.dart';
import 'package:notes_app/services/supabase_service.dart';
import 'package:notes_app/widgets/login_screen.dart';
import 'package:notes_app/widgets/notes.dart';
import 'package:notes_app/widgets/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://rjqxcoszkschqdnrriio.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJqcXhjb3N6a3NjaHFkbnJyaWlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzA3NTM1NjUsImV4cCI6MjA0NjMyOTU2NX0.z644HIZnUFUOVQEkNiO0o_ctmWUdEgkwtgiAT_ocYuE',
  );

  final authService = AuthService();
  final supabaseService = SupabaseService(authService);

  runApp(MaterialApp(
    initialRoute: '/login',
    routes: {
      '/login': (context) => const LoginScreen(),
      '/register': (context) => const RegisterScreen(),
      '/notes': (context) => const Notes(),
    },
    theme: ThemeData(scaffoldBackgroundColor: Colors.white),
  ));
}
