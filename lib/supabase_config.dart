import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = "https://rjqxcoszkschqdnrriio.supabase.co";
  static const String supabaseAnnonKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJqcXhjb3N6a3NjaHFkbnJyaWlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzA3NTM1NjUsImV4cCI6MjA0NjMyOTU2NX0.z644HIZnUFUOVQEkNiO0o_ctmWUdEgkwtgiAT_ocYuE";

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnnonKey,
    );
  }
}
