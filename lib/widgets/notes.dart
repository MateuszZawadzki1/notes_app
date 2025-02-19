import 'package:flutter/material.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() {
    return _NotesState();
  }
}

class _NotesState extends State<Notes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        leading: PopupMenuButton<String>(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: "Log out",
              child: Text("Log out"),
            ),
          ],
          icon: const Icon(Icons.menu),
        ),
        bottom: PreferredSize(
            preferredSize: Size(50, 50),
            child: IconButton(onPressed: () {}, icon: Icon(Icons.add))),
      ),
      body: const Column(
        children: [
          Text("List of notes"),
        ],
      ),
    );
  }
}
