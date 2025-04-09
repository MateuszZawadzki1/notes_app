import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/blocs/auth/auth_bloc.dart';
import 'package:notes_app/blocs/auth/auth_event.dart';
import 'package:notes_app/blocs/auth/auth_state.dart';
import 'package:notes_app/l10n_extension.dart';
import 'package:notes_app/services/auth_service.dart';
import 'package:notes_app/widgets/notes.dart';
import 'package:notes_app/widgets/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _login() {
    context.read<AuthBloc>().add(
          AuthLoginRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute<Notes>(builder: (context) => const Notes()),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 75),
                ),
                const Icon(Icons.person_2_outlined, size: 100),
                const SizedBox(height: 20),
                Text(
                  context.l10n.logIn,
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Email',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: context.l10n.password,
                  ),
                ),
                const SizedBox(height: 10),
                if (state is AuthFailure)
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 20),
                if (state is AuthLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(
                      context.l10n.logIn,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 15,
                ),
                Text(context.l10n.or),
                const SizedBox(
                  height: 15,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<RegisterScreen>(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: Text(
                    context.l10n.createAnAccout,
                    style: const TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
