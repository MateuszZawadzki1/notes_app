import 'package:flutter/material.dart';
import 'package:notes_app/services/auth_service.dart';
import 'package:notes_app/widgets/notes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Instancja AuthService jest tworzona tylko raz – tutaj w polu klasy.
  final AuthService authService = AuthService();

  // Kontrolery do pobierania danych z pól tekstowych.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final bool success = await authService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;

      if (!success) {
        // Jeśli logowanie nie powiodło się, ustaw komunikat błędu i zakończ funkcję
        setState(() {
          _errorMessage = "Invalid email or password";
        });
        return;
      }

      // Jeśli logowanie powiodło się, przechodzimy do ekranu notatek
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Notes()),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_2_outlined, size: 80),
            const SizedBox(height: 20),
            const Text(
              "Log in",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Pole do wpisania e-maila
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Email",
              ),
            ),
            const SizedBox(height: 10),
            // Pole do wpisania hasła
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Password",
              ),
            ),
            const SizedBox(height: 10),
            // Wyświetlamy komunikat o błędzie, jeśli wystąpił.
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20),
            // Jeśli trwa ładowanie, pokazujemy loader, inaczej przycisk logowania.
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: const Text("Log in"),
                  ),
          ],
        ),
      ),
    );
  }
}
