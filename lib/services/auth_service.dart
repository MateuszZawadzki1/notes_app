import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@injectable
class AuthService {
  String? get accessToken =>
      Supabase.instance.client.auth.currentSession?.accessToken;

  Future<bool> login(String email, String password) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.session != null; // Zwraca true, jeśli sesja istnieje
    } catch (e) {
      print("Login error: $e");
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );
      return response.user != null; // Zwraca true, jeśli użytkownik utworzony
    } catch (e) {
      print("Register error: $e");
      return false;
    }
  }

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
  }
}
