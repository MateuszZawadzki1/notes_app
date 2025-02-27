import 'package:flutter/material.dart';
import 'package:notes_app/widgets/notes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Icon(Icons.person_2_outlined),
          const Text("Log in"),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Username",
            ),
          ),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Password",
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Notes()));
            },
            child: Text("Log in"),
          ),
        ],
      ),
    );
  }
}
