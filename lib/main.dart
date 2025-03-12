import 'package:flutter/material.dart';
import 'package:notes_app/services/auth_service.dart';
import 'package:notes_app/services/supabase_service.dart';
import 'package:notes_app/widgets/login_screen.dart';
import 'package:notes_app/widgets/notes.dart';

void main() {
  final authService = AuthService();
  final supabaseService = SupabaseService(authService);

  runApp(const MaterialApp(home: LoginScreen() //Notes(),
      // TODO: Theming TextButton, TitleFont
      ));
}
