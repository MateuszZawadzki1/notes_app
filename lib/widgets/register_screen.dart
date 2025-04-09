import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/blocs/auth/auth_bloc.dart';
import 'package:notes_app/blocs/auth/auth_event.dart';
import 'package:notes_app/blocs/auth/auth_state.dart';
import 'package:notes_app/l10n_extension.dart';
import 'package:notes_app/widgets/notes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _register() {
    context.read<AuthBloc>().add(
          AuthRegisterRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
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
                const Icon(Icons.person_2_outlined, size: 100),
                const SizedBox(height: 20),
                Text(
                  context.l10n.signUp,
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
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      context.l10n.signUp,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
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
